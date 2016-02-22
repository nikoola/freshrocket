class SendDispatchSmsJob < ActiveJob::Base
	queue_as :sms

	def perform name, phone
		text = "Dear #{name},Your order has been dispatched and will be delivered within 60 minutes! Regards, FreshRocket Support Team"

		client = Smslane::Client.new(SMSLANE[:username], SMSLANE[:password])

		client.send_sms [phone], text, false
	end
end

