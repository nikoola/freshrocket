class PositionsController < ApplicationController

	before_action :set_order, only: [:index]


	# list all positions for current order
	def index
		positions = redis.lrange "deliveries:#{@order.id}", 0, -1

		render json: { positions: positions }, status: 200
	end

	private

		def set_order
			unless @order = Order.find_by(id: params[:order_id])
				head status: 404
			end

		end


end
