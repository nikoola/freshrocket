require 'rails_helper'

resource 'admin: stats', type: :request do

	let(:user) { FactoryGirl.create :user, abilities: [:orders] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'


	get '/admin/stats' do
		example 'get stats' do
			FactoryGirl.create_list :order, 3

			do_request
			parsed = JSON.parse(response_body)

			expect(parsed['orders']['today']).to eq(3)
			expect(parsed['users']['all']).to eq(User.count)
		end
	end





end








