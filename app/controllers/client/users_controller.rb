module Client
	class UsersController < BaseController


		# GET /users/1
		def show
			render json: current_user
		end

		def send_verification_sms
			current_user.update!(verification_code: rand(1000..9999))

			SendVerificationSmsJob.perform_later current_user.name, current_user.phone, current_user.verification_code
			
			head 200
		end


		def verify
			if current_user.verification_code == params[:verification_code]
				current_user.update!(is_verified: true)
				head 200
			else
				render json: { :error => "Invalid verification code." }, status: 422 
			end
		end




		def send_email_to_recover_password
			if current_user.send_reset_password_instructions
				head 200	
			end
		end


	end
end