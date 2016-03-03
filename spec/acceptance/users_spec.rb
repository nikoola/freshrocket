require 'rails_helper'
include ActiveJob::TestHelper
ActiveJob::Base.queue_adapter = :test




resource 'users', type: :request do


	post '/users/send_sms_with_recovery_password' do

		example 'sends password recovery email' do
			explanation 'resets password and creates new temporary password, that client should change some time after the log in'

			user = FactoryGirl.create :user
			expect {
				do_request phone: user.phone
			}.to have_enqueued_job.on_queue('sms')

			expect(status).to eq(200)
		end


		example 'with nonexistent phone number in params', document: false  do
			nonexistent_phone = '917777777777'
			do_request phone: nonexistent_phone

			expect(status).to eq(422)
			expect(json).to eq :errors=>"no user with such phone registered"
		end

	end


end