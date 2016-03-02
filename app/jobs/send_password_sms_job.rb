class SendPasswordSmsJob < ActiveJob::Base
	queue_as :sms

	def perform name, password, phone
		text = "Dear #{name}, here is your password: #{password}. Regards, FreshRocket."

		client = Smslane::Client.new(SMSLANE[:username], SMSLANE[:password])

		client.send_sms [phone], text, false
	end
end

