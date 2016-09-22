module Client
	class PaymentsController < ApplicationController #for authenticated only TODO later
		before_action :authenticate_user!, only: [:new]

		def new
			unless @order = current_user.orders.find_by(id: params[:order_id])
				head status: 404
			end

			# citrus_helper = OffsitePayments::Integrations::Citrus::Helper.new(
			# 	@order.id, CITRUS[:access_key],
			# 	amount: @order.total_price, currency: 'INR',
			# 	credential2: CITRUS[:secret_key],
			# 	credential3: CITRUS[:vanity_url],
			# 	return_url:  CITRUS[:return_url]
			# )


			account = 'FreshD33860006728322'
			paytm_helper = OffsitePayments::Integrations::Paytm::Helper.new(@order.id, account, {
				merchant_key:      ENV['paytm.merchant_key'],
				amount:            params[:total_price],
				transaction_type: 'DEFAULT',
				device_used:      'WEB',
				customer: {
					email: current_user.email,
					phone: current_user.phone,
					id:    current_user.id
				},
				industry_type_id: 'Retail',
				website:          'FreshDispatchweb',
				notify_url:       'http://requestb.in/136wzmc1' 
			})
	

			render json: {
				# citrus: { 
				# 	action: citrus_helper.credential_based_url,
				# 	method: citrus_helper.form_method, 
				# 	fields: citrus_helper.form_fields
				# },
				paytm: {
					action: OffsitePayments::Integrations::Paytm.service_url,
					method: paytm_helper.form_method, 
					fields: paytm_helper.form_fields 
				}
			}
		end
	
		# This was a quick spike and to get the requests working I added the skip_before_action :verify_authenticity_token callback to the controller which you will not want to do in production. If I have time I'll fix that and update this repo.

		# paypal posts here after transaction
		def citrus
			@notification = OffsitePayments.integration(:citrus).notification(
				request.raw_post
			)

			if @notification.acknowledge # check if it’s genuine Citrus request

				@order = Order.find(@notification.item_id)
				@order.update(payment_type: :citrus, is_paid: true)
				@order.confirm!

				head 200
			else
				head :bad_request
			end

		end


		def paytm
			notification = OffsitePayments::Integrations::Paytm::Notification.new params.except(:controller, :action)
			if notification.acknowledge ENV['paytm.merchant_key']
				if notification.success?
					order = Order.find(notification.item_id)
					order.update(payment_type: :paytm, is_paid: true)

					head 200
				else
					render json: { status: notification.status }
				end
			else
				render json: { status: "It's not Paytm sending us stuff" }, status: :bad_request
			end

		end

	end
end