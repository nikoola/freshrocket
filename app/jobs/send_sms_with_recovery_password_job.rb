class SendSmsWithRecoveryPasswordJob < ActiveJob::Base
	queue_as :sms

	def perform name, temporary_password, phone
		text = "Dear #{name}, your new temporary password is: #{temporary_password}.  Regards, FreshRocket."

		client = Smslane::Client.new(SMSLANE[:username], SMSLANE[:password])

		client.send_sms [phone], text, false
	end
end

