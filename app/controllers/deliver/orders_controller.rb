module Deliver
	class OrdersController < BaseController
		before_action :set_order, only: [:update_status]
		

		def index
			@orders = current_user.delivery_boy.orders.filter params.slice(:status)

			render json: @orders
		end

		# TODO: update paid with cash


		def update_status
			action = params[:order][:action]

			if action.to_sym.in? [:deliver]
				@order.update_status action
				if @order.errors.empty?
					head 200
				else
					render json: @order.errors, status: :unprocessable_entity
				end
			else
				render json: { error: "this user can't #{action} order" }, status: 401
			end

		end



		private

			def set_order
				head status: 404 unless @order = current_user.delivery_boy.orders.find_by(id: params[:id])
			end

	end
end