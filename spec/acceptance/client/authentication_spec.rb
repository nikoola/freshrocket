require 'rails_helper'

resource 'client: authentication', type: :request do

	let(:user) { FactoryGirl.create :user }
	let(:auth_headers) { user.create_new_auth_token }

	post '/auth/sign_in' do
		parameter :email,    "registered user's email",    required: true
		parameter :password, "registered user's password", required: true

		it 'sign in' do
			explanation 'returns "access-token", "token-type", "client", "expiry", "uid" in response headers, which we can then use to access protected resources'
			do_request email: user.email, password: user.password


			expect(status).to eq 200
			expect(json[:data].keys).to include :id, :email, :phone, :provider, :uid, :abilities
			expect(response_headers).to include("access-token", "token-type", "client", "expiry", "uid")
		end
	end

	delete '/auth/sign_out' do
		describe 'signed in' do
			include_context 'shared_headers'
			it 'sign out' do
				do_request

				expect(status).to eq(200)
				expect(json).to include success: true
			end
		end

		it 'sign out: if not signed in' do
			do_request

			expect(status).to eq(404)
			expect(json).to include :errors=>["User was not found or was not logged in."]
		end
	end



	# Requires uid, client, and access-token as params
	get '/auth/validate_token' do

		it 'is serialized properly' do
			do_request auth_headers


			expect(json[:success]).to eq(true)
			expect(json[:data]).to include(:abilities)
		end


	end










end
