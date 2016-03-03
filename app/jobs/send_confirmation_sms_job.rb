class SendConfirmationSmsJob < ActiveJob::Base
	queue_as :sms

	def perform name, phone
		text = "Dear #{name}, your order has been received. Regards, FreshRocket."

		client = Smslane::Client.new(SMSLANE[:username], SMSLANE[:password])

		client.send_sms [phone], text
	end
end

