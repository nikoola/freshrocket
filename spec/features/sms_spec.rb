require 'rails_helper'

describe 'Sms' do

	let(:name) { 'hi' }
	let(:verification_code) { '1516' }
	let(:text) { "Dear #{name}, Your verification code is #{verification_code} , Regards, FreshRocket" }
	let(:mobile_number) { '9234567888' }
	

	# it 'smslane' do
	# 	client = Smslane::Client.new(SMSLANE[:username], SMSLANE[:password])
		
	# 	expect(client.check_balance[:result]).to eq('Success')

	# 	# response = client.send_sms ['919234567888'], text, false
	# 	# expect(response[0].keys).to include(:number, :message_id) #works
	# end

	# it 'msg91' do
	# 	p Msg91::Client.text(mobile_number, text)
	# end
end






