module Admin
	class DeliveryBoysController < BaseController
		# before_action :set_delivery_boy, only: [:show]
		before_action -> { authorize 'users' }


		def index
			@delivery_boys = DeliveryBoy.includes(:user).where(["status <> ?", "fired"]).filter(params.slice(:status)).joins(:user => :addresses ).where( :addresses => {city_id: params[:city_id]} )

# binding.pry
			render json: @delivery_boys#, include: :user
		end


		def create
			user = User.find(delivery_boy_params[:user_id])
			user.add_ability(:delivery_boy)
			user.save
			# binding.pry
			@delivery_boy = DeliveryBoy.find_by_user_id(user.id)

			@delivery_boy.update(delivery_boy_params.slice(:status))
			if @delivery_boy.save
				render json: @delivery_boy, status: :created
			else
				render json: @delivery_boy.errors, status: :unprocessable_entity
			end
		end

		private

			# def set_delivery_boy
			# 	@delivery_boy = DeliveryBoy.find(params[:id])
			# end

			def delivery_boy_params
				params[:delivery_boy].permit([
					:status, :user_id, :city_id
				])
			end
	end

end