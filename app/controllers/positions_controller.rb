class PositionsController < ApplicationController

	before_action :set_order, only: [:index]
	before_action :authenticate_user!



	# list all positions for current order
	def index
		a = current_user.has_ability?('delivery_boy') and 
				@order.delivery_boy.id == current_user.delivery_boy.id
		b = current_user.has_ability? 'orders'
		c = current_user.id == @order.user.id

		if a or b or c
			positions = redis.lrange "deliveries:#{@order.id}", 0, -1

			render json: { positions: positions }, status: 200
		else
			head 401
		end

	end

	private

		def set_order
			unless @order = Order.find_by(id: params[:order_id])
				head 404
			end

		end


end
