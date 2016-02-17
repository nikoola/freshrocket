class SendVerificationSmsJob < ActiveJob::Base
	queue_as :default

	def perform phone, phone_verification_code
		twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
		twilio_client.account.sms.messages.create(
			:from => ENV['TWILIO_PHONE_NUMBER'],
			:to => current_user.phone,
			:body => "Your verification code is #{current_user.verification_code}."
		)
	end
end

