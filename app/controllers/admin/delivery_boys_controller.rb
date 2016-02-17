module Admin
	class DeliveryBoysController < BaseController
		# before_action :set_delivery_boy, only: [:show]
		before_action -> { authorize 'users' }


		def index
			@delivery_boys = DeliveryBoy.filter params.slice(:status)

			render json: @delivery_boys
		end




		private

			# def set_delivery_boy
			# 	@delivery_boy = DeliveryBoy.find(params[:id])
			# end

			# def delivery_boy_params
			# 	params[:delivery_boy].permit([
			# 		:name
			# 	])
			# end
	end

end