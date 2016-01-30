require 'rails_helper'

RSpec.describe "Users", type: :request do

	describe "Authentication" do

		before(:all) do
			@admin_user = FactoryGirl.create :admin_user
			@admin_user_auth_headers = @admin_user.create_new_auth_token
		end

		before(:each) do
			@user = FactoryGirl.create :user
			@auth_headers = @user.create_new_auth_token #as if we signed in and remembered them already
		end

		# These routes correspond to the defaults used by the ng-token-auth module for AngularJS
		describe 'default devise routes (used by ng-token-auth)' do
			describe 'POST /auth' do
				it 'creates user with valid params' do
					post '/auth', FactoryGirl.attributes_for(:user, phone: '+7489234327') #devise_parameter_sanitizer
					expect_json status: 'success', data: {phone: '+7489234327'}
				end

				it 'return with invalid params' do
					post '/auth', FactoryGirl.attributes_for(:user, phone: nil)
					expect_json status: 'error', errors: {phone: ["can't be blank"]}
				end
			end

			describe 'DELETE /auth' do
				it 'user deletes self identified by authenticated headers' do
					delete '/auth', {}, @auth_headers
					expect_json status: 'success', message: /has been destroyed/
				end

				it '404 with no headers' do
					delete '/auth', {}#, @auth_headers
					expect_json status: 'error', errors: ["Unable to locate account for destruction."]
					expect_status 404
				end
			end

			describe 'PUT /auth' do
				it 'user updates self identified by authenticated headers with valid params' do
					put '/auth', { role: :admin, phone: '+7927333333' }, @auth_headers

					@user.reload
					expect(@user.role).not_to eq('admin') #application_controller, devise_parameter_sanitizer. should not be able to make itself admin.
					expect(@user.phone).to eq('+7927333333')

					expect_json status: 'success', data: @user.attributes.slice(:phone, :role, :email)
				end

				it 'user updates self identified by authenticated headers with invalid params' do
					put '/auth', { phone: nil }, @auth_headers

					expect_json status: 'error', errors: {:phone=>["can't be blank"]}
				end
			end

		end


		describe 'GET /users' do
			it 'nonauthenticated - 401' do
				get users_path
				expect_status 401
			end

			it 'authenticated :client user - 401' do
				get users_path, {}, @auth_headers
				expect_status 401
			end

			it 'authenticated :admin user - 200' do
				@user = FactoryGirl.create :admin_user
				get users_path, {}, @user.create_new_auth_token
				
				expect_status 200

				returned_ids = json_body.map { |a| a[:id] }
				expect(returned_ids).to eq(User.pluck(:id))
			end
		end

		describe 'GET /users/1' do
			let(:another_user_auth_headers) { FactoryGirl.create(:user).create_new_auth_token }

			it 'nonauthenticated - 401' do
				get user_path(@user)
				expect_status 401
			end

			it 'authenticated :client user that owns the profile - 200' do
				get user_path(@user), {}, @auth_headers
				expect_status 200
			end

			it 'authenticated :client user that doesnt own the profile - 401' do
				get user_path(@user), {}, another_user_auth_headers
				expect_status 401
			end

			it 'authenticated :admin user - 200' do
				@user = FactoryGirl.create :admin_user
				get user_path(@user), {}, @user.create_new_auth_token
				
				expect_status 200
			end
		end

		describe 'POST /users' do

			it 'by admin, with valid params: user created' do
				post users_path, {user: FactoryGirl.attributes_for(:user)} , @admin_user_auth_headers
				expect_status 201
				expect_json_keys :id, :provider, :uid, :email, :phone, :role, :created_at, :updated_at
			end

			it 'by admin, with invalid params: errors returned' do
				post users_path, {user: FactoryGirl.attributes_for(:user, phone: nil)} , @admin_user_auth_headers
				expect_status 422
				expect_json :phone=>["can't be blank"]
			end

		end

		describe 'PUT /users/1' do
			it 'by admin, with valid params: user updated' do
				put user_path(@user), {user: {role: :admin}}, @admin_user_auth_headers
				expect_status 200
			end

			it 'admin can update other user roles to admin'
		end

		describe 'DELETE /users/1' do
			it 'by admin: user deleted' do
				delete user_path(@user), {}, @admin_user_auth_headers
				expect_status 200
			end
		end



	end
end
