require 'rails_helper'

resource 'Users', type: :request do

	let(:user) { FactoryGirl.create :user }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'


	# These routes correspond to the defaults used by the ng-token-auth module for AngularJS
	describe 'default devise routes (used by ng-token-auth)' do

		post '/auth' do
			example 'create user' do
				do_request FactoryGirl.attributes_for(:user, phone: '+7489234327') #devise_parameter_sanitizer

				expect(status).to eq(200)
				expect(json[:status]).to eq('success')
				expect(json[:data].keys).to include :id, :email, :phone, :provider, :uid, :created_at, :updated_at
			end

			example 'create user: invalid params' do
				do_request FactoryGirl.attributes_for(:user, phone: nil)

				expect(status).to eq(403)
				expect(json[:status]).to eq('error')
				expect(json[:errors].keys).to include :phone
			end
		end

		delete '/auth' do
			example_request 'user deletes self' do

				expect(status).to eq(200)
				expect(json[:status]).to eq('success')
				expect(json[:message]).to match(/has been destroyed/)
			end

			it '404 with no headers', document: false do
				delete '/auth', {}#, @auth_headers
				expect_json status: 'error', errors: ["Unable to locate account for destruction."]
				expect_status 404
			end
		end

		put '/auth' do
			it 'user updates self' do
				do_request({ phone: '+7927333333' })

				user.reload
				# expect(user.role).not_to eq('admin') #application_controller, devise_parameter_sanitizer. should not be able to make itself admin.
				expect(user.phone).to eq('+7927333333')

				expect(status).to eq(200)
				expect(json[:status]).to eq('success')
				expect(json[:data].keys).to include :id, :email, :phone, :provider, :uid, :created_at, :updated_at
			end

			it 'user updates self: invalid params' do
				do_request({ phone: nil })

				expect(status).to eq(403)
				expect(json[:status]).to eq('error')
				expect(json[:errors]).to include :phone=>["can't be blank"], :full_messages=>["Phone can't be blank"]
			end
		end

	end



	get '/client' do
		let(:another_user_auth_headers) { FactoryGirl.create(:user).create_new_auth_token }

		example_request 'user gets self' do
			explanation 'status 401 if user unauthenticated'

			expect(status).to eq(200)
			expect(json.keys).to include :id, :provider, :uid, :email, :phone, :created_at, :updated_at
		end

		it 'unauthenticated user - 401', document: false do
			get '/client'
			expect_status 401
		end

	end





end
