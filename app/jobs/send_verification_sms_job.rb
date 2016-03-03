class SendVerificationSmsJob < ActiveJob::Base
	queue_as :sms

	def perform name, phone, verification_code

		text = "Dear #{name}, your verification code is #{verification_code}. Regards, FreshRocket."

		client = Smslane::Client.new(SMSLANE[:username], SMSLANE[:password])

		# An array of recipient numbers
		# The message to be sent
		# A boolean indicating whether or not to send the SMS as a flash message
		client.send_sms [phone], text


		# The response of this call is an array of hashes. Each hash contains the recipient number and the message_id returned by smslane.com. This message_id is used to check delivery reports.
	end
end

