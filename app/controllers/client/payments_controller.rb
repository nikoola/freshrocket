module Client
	class PaymentsController < ApplicationController #for authenticated only TODO later
		before_action :authenticate_user!, only: [:new]

		def new
			head status: 404 unless @order = current_user.orders.find_by(id: params[:order_id])

			citrus_helper = OffsitePayments::Integrations::Citrus::Helper.new(
				@order.id, CITRUS[:access_key],
				amount: @order.total_price, currency: 'INR',
				credential2: CITRUS[:secret_key],
				credential3: CITRUS[:vanity_url],
				return_url:  CITRUS[:return_url]
			)

			# paytm_helper = OffsitePayments::Integrations::Paytm::Helper.new('order-500', 'cody@example.com',
			# 	amount:            500,
			# 	transaction_type: 'DEFAULT',
			# 	device_used:      'WEB',
			# 	customer: {
			# 		email: 'hi@hi.com',
			# 		phone: '9111111111',
			# 		id:    1
			# 	},
			# 	industry_type_id: 3,
			# 	website:          'http://hi.com'
			# )
	

			render json: {
				citrus: { 
					action: citrus_helper.credential_based_url, 
					method: citrus_helper.form_method, 
					fields: citrus_helper.form_fields
				}#,
				# paytm: {
				# 	action: OffsitePayments::Integrations::Paytm.service_url, 
				# 	method: paytm_helper.form_method, 
				# 	fields: paytm_helper.form_fields 
				# }
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









	end
end