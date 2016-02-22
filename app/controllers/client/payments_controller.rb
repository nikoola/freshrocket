module Client
	class PaymentsController < ApplicationController #for authenticated only TODO later

		def new
			helper = OffsitePayments::Integrations::Citrus::Helper.new(
				'11111', CITRUS[:access_key],
				amount: 10, currency: 'USD',
				credential2: CITRUS[:secret_key],
				credential3: CITRUS[:vanity_url],
				return_url:  CITRUS[:return_url]
			)


			render json: { 
				citrus: { 
					action: helper.credential_based_url, 
					method: helper.form_method, 
					fields: helper.form_fields 
				}
			}
		end
	
		# This was a quick spike and to get the requests working I added the skip_before_action :verify_authenticity_token callback to the controller which you will not want to do in production. If I have time I'll fix that and update this repo.

		# paypal sends this shit to me
		def citrus

			@notification = OffsitePayments.integration(:citrus).notification(
				request.raw_post
			)

			if @notification.acknowledge # check if it’s genuine Citrus request

				@order = Order.find(@notification.item_id)
				@order.update(payment_type: :citrus, paid: true)

				head 200
			else
				head :bad_request
			end

		end









	end
end