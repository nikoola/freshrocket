module DeliveryBoy
	class DeliveriesController < ApplicationController
		before_action :set_delivery, only: [:update_status]
		before_action :authenticate_user!, -> { authorize 'delivery_boy' }

		# GET /admin/deliveries
		def index
			@deliveries = current_user.deliveries#.filter params.slice(:city_id, :user_id, :status, :limit, :offset)

			render json: @deliveries
		end


		# def update_status
		# 	action = params[:delivery][:action]

		# 	if action.to_sym.in? [:deliver]
		# 		@delivery.update_status action
		# 		if @delivery.errors.blank?
		# 			head 200
		# 		else
		# 			render json: @delivery.errors, status: :unprocessable_entity
		# 		end
		# 	else
		# 		render json: {error: "this user can't #{action} delivery"}, status: 401
		# 	end

		# end

		private

			def set_delivery
				head status: 404 unless @delivery = current_user.deliveries.find_by(id: params[:id])
			end

			def delivery_params
				# params[:delivery].permit([
				# 	:wanted_date, :wanted_time,
				# 	:order_id, :
				# 	line_items_attributes: [:_destroy, :id, :amount, :product_id]
				# ])

				#no user_id, no use case when admin would need to change the delivery's user
			end
	end

end