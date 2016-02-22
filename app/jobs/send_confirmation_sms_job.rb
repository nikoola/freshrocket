class SendConfirmationSmsJob < ActiveJob::Base
	queue_as :sms

	def perform name, phone
		text = "Dear #{name},Your order has been received! Regards, FreshRocket Support Team"

		client = Smslane::Client.new(SMSLANE[:username], SMSLANE[:password])

		client.send_sms [phone], text, false
	end
end

