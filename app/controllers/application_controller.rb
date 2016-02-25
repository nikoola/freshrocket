
class ApplicationController < ActionController::Base
	include DeviseTokenAuth::Concerns::SetUserByToken

	protect_from_forgery with: :exception


	before_action :configure_permitted_parameters, if: :devise_controller?

	protected

		# applicable to ng routes only
		def configure_permitted_parameters
			# devise_parameter_sanitizer.for(:account_update) << :role #WORKS
			devise_parameter_sanitizer.for(:account_update) << :phone
			devise_parameter_sanitizer.for(:account_update) << :city_id
			devise_parameter_sanitizer.for(:account_update) << :first_name
			devise_parameter_sanitizer.for(:account_update) << :last_name
			devise_parameter_sanitizer.for(:account_update) << :reset_password_token #timely
			devise_parameter_sanitizer.for(:account_update) << :redirect_url 
			#timely


			# devise_parameter_sanitizer.for(:sign_up) << :role
			devise_parameter_sanitizer.for(:sign_up) << :phone
			devise_parameter_sanitizer.for(:sign_up) << :city_id
			devise_parameter_sanitizer.for(:sign_up) << :first_name
			devise_parameter_sanitizer.for(:sign_up) << :last_name


			devise_parameter_sanitizer.for(:account_update) { |u| 
			  u.permit(:password, :password_confirmation, :current_password) 
			} #timely

			#TODO :email, :password, :password_confirmation, :role, :phone
			# devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email,...) }
			# doesn't seem to work?
			# http://stackoverflow.com/questions/19791531/how-to-specify-devise-parameter-sanitizer-for-edit-action
		end

	private

		def authorize ability
			unless current_user.has_abillity? ability
				render json: { error: "user doesn't have a #{ability} ability to access this page" }, status: 401
			end
		end




end
