require 'rails_helper'

resource 'client: users', type: :request do

	let(:user) { FactoryGirl.create :user }
	let(:auth_headers) { user.create_new_auth_token }

	let(:new_phone) { FactoryGirl.attributes_for(:user)[:phone].to_s }

	include_context 'shared_headers'


	# These routes correspond to the defaults used by the ng-token-auth module for AngularJS
	describe 'default devise routes (used by ng-token-auth)' do

		post '/auth' do
			with_options required: true do
				parameter 'phone'
				parameter 'email'
				parameter 'password'
				parameter 'password_confirmation'
				parameter 'first_name'
				parameter 'last_name'
			end

			parameter 'how_did_you_hear_about_us'

			example 'create user' do
				do_request FactoryGirl.attributes_for(:user, 
					phone: new_phone
				) #devise_parameter_sanitizer

				expect(status).to eq(200)
				expect(json[:status]).to eq('success')
				expect(json[:data].keys).to include :id, :email, :phone, :provider, :uid, :created_at, :updated_at, :is_verified
			end

			example 'create user: invalid params' do
				do_request FactoryGirl.attributes_for(:user, phone: nil)

				expect(status).to eq(403)
				expect(json[:status]).to eq('error')
				expect(json[:errors].keys).to include :phone
			end
		end

		# delete '/auth' do
		# 	example_request 'user deletes self' do

		# 		expect(status).to eq(200)
		# 		expect(json[:status]).to eq('success')
		# 		expect(json[:message]).to match(/has been destroyed/)
		# 	end

		# 	it '404 with no headers', document: false do
		# 		delete '/auth', {}#, @auth_headers
		# 		expect_json status: 'error', errors: ["Unable to locate account for destruction."]
		# 		expect_status 404
		# 	end
		# end

		put '/auth' do

			it 'user updates self' do
				explanation 'if phone is updates, is_verified is set to false'
				do_request({ phone: new_phone })

				user.reload
				# expect(user.role).not_to eq('admin') #application_controller, devise_parameter_sanitizer. should not be able to make itself admin.
				expect(user.phone).to eq(new_phone)
				expect(user.is_verified).to be(false)

				expect(status).to eq(200)
				expect(json[:status]).to eq('success')
				expect(json[:data].keys).to include :id, :email, :phone, :provider, :uid, :created_at, :updated_at
			end

			it 'user updates self: invalid params' do
				do_request({ phone: nil })

				expect(status).to eq(403)
				expect(json[:status]).to eq('error')
				expect(json[:errors][:phone]).to include "can't be blank", "is not a number"
			end

			it 'can change email', document: false do
				new_email = 'wow@wow.com'
				do_request(email: new_email)

				expect(status).to eq(200)
				expect(json[:data][:email]).to eq(new_email)
			end
		end

	end



	get '/client' do
		let(:another_user_auth_headers) { FactoryGirl.create(:user).create_new_auth_token }

		example_request 'user gets self' do
			explanation 'status 401 if user unauthenticated'

			expect(status).to eq(200)
			expect(json.keys).to include :id, :provider, :uid, :email, :phone, :created_at
		end

		it 'unauthenticated user - 401', document: false do
			get '/client'
			expect_status 401
		end

	end



	put '/client/verify' do
		parameter :verification_code

		example 'verifies phone' do

			do_request verification_code: user.verification_code

			expect(status).to eq(200)
			expect(user.reload.is_verified).to eq(true)
		end

	end







end
