module Deliver
	class PositionsController < BaseController
		before_action :set_order, only: [:create]
		

		# add new position
		def create
			redis.lpush "deliveries:#{@order.id}", params[:position]

			head 201
		end




		private

			def set_order
				head status: 404 unless @order = current_user.delivery_boy.orders.find_by(id: params[:id])
			end



	end
end