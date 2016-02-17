module Admin
	class UsersController < BaseController

		before_action :set_user, only: [:show, :update, :destroy, :update_abilities, :list_abilities]
		before_action -> { authorize 'users' }

		# GET /users
		def index
			@users = User.filter params.slice(:email_includes, :phone_includes, :has_abillity)

			render json: @users
		end

		# GET /users/1
		def show
			render json: @user
		end

		# # POST /users
		# def create
		# 	@user = User.new(user_params)
		# 	if @user.save
		# 		render json: @user, status: :created, location: admin_user_path(@user)
		# 	else
		# 		render json: @user.errors, status: :unprocessable_entity
		# 	end
		# end

		# PATCH/PUT /users/1
		def update

			if @user.update(user_params)
				if params[:user][:is_verified] == 'true'
					@user.update! is_verified: true # because if phone changed is_verified will be reset to false.
					# alternative is passing current_user to the model.
				end
				render json: @user, status: 200
			else
				render json: @user.errors, status: :unprocessable_entity
			end
		end

		# # DELETE /users/1
		# def destroy
		# 	@user.destroy
		# 	head 200
		# end


		def list_abilities
			manipulation = ManipulateUserAbilities.new @user
			hash = manipulation.list

			render json: {abilities: hash}, status: 200
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
				params.require(:user).permit(:city_id, :phone)
			end






	end
end