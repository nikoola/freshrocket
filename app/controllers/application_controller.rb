
class ApplicationController < ActionController::Base
	include DeviseTokenAuth::Concerns::SetUserByToken


	before_action :configure_permitted_parameters, if: :devise_controller?





	protected

		# applicable to ng routes only
		def configure_permitted_parameters
			[ 
				:phone, :city_id, 
				:first_name, :last_name, 
				:how_did_you_hear_about_us
			].each do |attribute|
				# devise_parameter_sanitizer.for(:account_update) << attribute
				devise_parameter_sanitizer.permit(:account_update, keys: [attribute])
				devise_parameter_sanitizer.permit(:sign_up, keys: [attribute])
				# devise_parameter_sanitizer.for(:sign_up)        << attribute
			end


			devise_parameter_sanitizer.permit(:account_update) { |u|
			  u.permit(:password, :password_confirmation, :current_password) 
			} #timely

			# devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email,...) }
			# doesn't seem to work?
			# http://stackoverflow.com/questions/19791531/how-to-specify-devise-parameter-sanitizer-for-edit-action
		end

	private

		def authorize ability
			unless current_user.has_ability? ability
				render json: { error: "user doesn't have a #{ability} ability to access this page" }, status: 401
			end
		end




end
