module Client
	class OrdersController < BaseController
		before_action :set_order, only: [:show, :update, :destroy]

		# GET /client/orders
		def index
			@orders = current_user.orders.filter params.slice(:status)

			render json: @orders
		end

		# GET /client/orders/1
		def show
			render json: @order
		end

		# POST /client/orders
		def create
			@order = current_user.orders.new(order_params)

			if @order.save
				render json: @order, status: :created, location: client_order_path(@order)
			else
				render json: @order.errors, status: :unprocessable_entity
			end
		end

		# PATCH/PUT /client/orders/1
		def update
			if @order.update(order_params)
				render json: @order, status: 200
			else
				render json: @order.errors, status: :unprocessable_entity
			end
		end

		# DELETE /client/orders/1
		def destroy
			@order.destroy

			head 200
		end

		private

			def set_order
				@order = current_user.orders.find(params[:id])
			end

			def order_params
				params.require(:order).permit([
					:status, :comment,
					line_items_attributes: [:_destroy, :id, :amount, :product_id]
				])

				# no :fixed_price.
			end
	end
end