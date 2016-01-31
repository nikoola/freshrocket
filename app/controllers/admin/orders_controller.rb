module Admin
	class OrdersController < ApplicationController
		before_action :set_order, only: [:show, :update, :destroy]
		before_action :authenticate_user!, -> { authorize Order }

		# GET /orders
		def index
			@orders = Order.filter params.slice(:user_id, :status)

			render json: @orders
		end

		# GET /orders/1
		def show
			render json: @order
		end

		# POST /orders
		def create
			@order = Order.new(order_params)

			if @order.save
				render json: @order, status: :created, location: @order
			else
				render json: @order.errors, status: :unprocessable_entity
			end
		end

		# PATCH/PUT /orders/1
		def update
			@order = Order.find(params[:id])

			if @order.update(order_params)
				render json: @order, status: 200
			else
				render json: @order.errors, status: :unprocessable_entity
			end
		end

		# DELETE /orders/1
		def destroy
			@order.destroy

			head 200
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
			end
	end

end