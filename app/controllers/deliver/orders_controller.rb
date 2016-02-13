module Deliver
	class OrdersController < BaseController
		before_action :set_order, only: [:update_status]
		

		def update_status #@order must be current_user's
			action = params[:order][:action]

			if action.to_sym == :deliver
				@order.update_status action
				if @order.errors.empty?
					head 200
				else
					render json: @order.errors, status: :unprocessable_entity
				end
			else
				render json: {error: "this user can't #{action} order"}, status: 401
			end
		end



		private

			def set_order
				head status: 404 unless @order = current_user.orders_to_deliver.find_by(id: params[:id])
			end

			def order_params
				params.require(:order).permit([
					:comment,
					delivery_attributes: [:id, :wanted_date, :wanted_time],
					line_items_attributes: [:_destroy, :id, :amount, :product_id]
				])

				# no :fixed_price, :status, :user_id
			end
	end
end