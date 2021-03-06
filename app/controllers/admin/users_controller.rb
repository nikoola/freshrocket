module Admin
	class UsersController < BaseController

		before_action :set_user, only: [:show, :update, :destroy, :update_abilities]
		#before_action -> { authorize 'users' }

		# GET /users
		def index
			
			city_id = params[:city].present? ? JSON.parse(params[:city])['id'] : '*'
			#city_id filter is not working now
			# unless city_id
				users = User.filter params.slice(:has_ability, :city_id, :phone_includes)#.merge({:city_id => city_id})
				# binding.pry
				render json: users, include: params[:include] #and return true

			# end

			# # addresses =  Address.where(city_id: city_id)
			# # @users = []
			# # addresses.map { |address| @users << address.user}

			# @users = User.city_id city_id
			# render json: @users, include: params[:include]
		end

		# GET /users/1
		def show
			render json: @user, include: params[:include]
		end

		# POST /users
		def create
			@user = User.new(user_params)
			# binding.pry
			if @user.save
				set_is_verified
				SendSmsWithRecoveryPasswordJob.perform_later @user.name, params[:user][:password], @user.phone
				render json: @user, status: :created, location: admin_user_path(@user)
			else
				render json: @user.errors, status: :unprocessable_entity
			end
		end

		def update

			if @user.update(user_params)
				set_is_verified
				render json: @user, status: 200
			else
				render json: @user.errors, status: :unprocessable_entity
			end
		end



		def update_abilities
			manipulation = ManipulateUserAbilities.new @user, params[:abilities]
			manipulation.update

			if @user.save
				head 200
			else
				render json: @user.errors, status: :unprocessable_entity
			end

		end

		private

			def set_user
				@user = User.find(params[:id])
			end

			def user_params
				params.require(:user).permit(
					:password, :password_confirmation,
					:phone, :email,
					:first_name, :last_name, 
					:how_did_you_hear_about_us, 
					:addresses_attributes => [:street_and_house,:lat, :lng, :door_number, :area_id, :city_id, :stringified_coordinate]
				)
			end

			def set_is_verified
				if params[:user][:is_verified].to_s == 'true'
					@user.update! is_verified: true # because if phone changed is_verified will be reset to false.
					# alternative is passing current_user to the model.
				end
			end




	end
end