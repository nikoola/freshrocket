require 'rails_helper'
include ActiveJob::TestHelper

describe ClientMailer do

	context 'when order is approved' do
		let(:order){ FactoryGirl.create(:order) }

		it 'job is created' do
			ActiveJob::Base.queue_adapter = :test
			expect {
				order.confirm!
				order.approve!
			}.to have_enqueued_job.on_queue('mailers')
		end

		it 'order_summary is sent' do
			expect {
				perform_enqueued_jobs do
					order.confirm!
					order.approve!
				end
			}.to change { ActionMailer::Base.deliveries.size }.by(1)

			mail = ActionMailer::Base.deliveries.last
			expect(mail.to[0]).to eq order.user.email
		end


	end




end