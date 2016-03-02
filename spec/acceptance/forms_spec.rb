require 'rails_helper'
include ActiveJob::TestHelper
ActiveJob::Base.queue_adapter = :test

resource 'forms', type: :request do

	post '/forms/contact' do
		with_options scope: :form do
			parameter :name,     '', required: true
			parameter :email,    '', required: true
			parameter :order_id
			parameter :message,  '', required: true
		end

		example 'send email to admins' do
			params = FactoryGirl.attributes_for(:contact_form)

			perform_enqueued_jobs do 
				do_request form: params
			end

			expect(status).to eq(200)

			mail = ActionMailer::Base.deliveries.last
			expect(mail.body).to include(params['message'])
		end


	end




end
