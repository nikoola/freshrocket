class SendDispatchSmsJob < ActiveJob::Base
	queue_as :sms

	def perform name, phone
		text = "Dear #{name}, your order has been dispatched and will be delivered within 60 minutes.  Regards, FreshRocket."

		client = Smslane::Client.new(SMSLANE[:username], SMSLANE[:password])

		client.send_sms [phone], text
	end
end

