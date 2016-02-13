module Deliver
	class DeliveryBoysController < BaseController
		before_action :set_delivery_boy, only: [:update]

		def update #@delivery_boy must be current_user's

			if @delivery_boy.update delivery_boy_params
				head 200
			else
				render json: @delivery_boy.errors, status: :unprocessable_entity
			end

		end


		private

			def set_delivery_boy
				@delivery_boy = current_user.delivery_boy
			end

			def delivery_boy_params
				params.require(:delivery_boy).permit([
					:lat, :long, :status
				])
			end
	end
end