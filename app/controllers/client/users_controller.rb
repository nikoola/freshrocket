module Client
	class UsersController < BaseController

		def show
			render json: current_user, include: params[:include]
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







	end
end