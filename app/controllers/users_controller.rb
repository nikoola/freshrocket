class UsersController < ApplicationController



	def send_sms_with_recovery_password
		user = User.find_by(phone: params[:phone])

		if user
			temporary_password = rand(10000000..99999999)
			user.update!(password: temporary_password, password_confirmation: temporary_password)

			SendSmsWithRecoveryPasswordJob.perform_later user.name, temporary_password, user.phone
		
			head 200
		else
			render json: { errors: 'no user with such phone registered' }, status: 422
		end

	end



end