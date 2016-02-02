module Admin
	class OrdersController < ApplicationController
		before_action :set_order, only: [:show, :update, :destroy, :update_status]
		before_action :authenticate_user!, -> { authorize Order }

		# GET /admin/orders
		def index
			@orders = Order.filter params.slice(:user_id, :status, :limit, :offset)

			render json: @orders
		end

		# GET /admin/orders/1
		def show
			render json: @order
		end

		# POST /admin/orders
		def create
			@order = Order.new(order_params)

			if @order.save
				render json: @order, status: :created, location: @order
			else
				render json: @order.errors, status: :unprocessable_entity
			end
		end

		# PATCH/PUT /admin/orders/1
		def update
			@order = Order.find(params[:id])

			if @order.update(order_params)
				render json: @order, status: 200
			else
				render json: @order.errors, status: :unprocessable_entity
			end
		end

		# DELETE /admin/orders/1
		def destroy
			@order.destroy
			head 200
		end

		def update_status
			action = params[:order][:action]

			if action.to_sym.in? [:approve, :dispatch, :deliver, :cancel]
				if @order.update_status action
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
				@order = Order.find(params[:id])
			end

			def order_params
				params[:order].permit([
					:status, :comment,
					line_items_attributes: [:_destroy, :id, :amount, :product_id]
				])

				#no user_id, no use case when admin would need to change the order's user
			end
	end

end