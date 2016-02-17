module Client 
	class BaseController < ::ApplicationController

		before_action :authenticate_user!


		private 
			def restrict_to_verified_users
				render json: { error: 'please verify your phone number to access this page' }, status: 401 unless current_user.is_verified
			end

	end
end