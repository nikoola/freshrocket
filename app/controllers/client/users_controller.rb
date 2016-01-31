module Client
	class UsersController < BaseController


		# GET /users/1
		def show
			render json: current_user
		end


	end
end