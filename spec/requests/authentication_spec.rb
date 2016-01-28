require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
	before(:all) do
		@user = FactoryGirl.create :user

		@auth_headers = @user.create_new_auth_token
			# {"access-token"=>"0C887ZJBsQDhbvtUBJGRCw",
			# "token-type"=>"Bearer",
			# "client"=>"GezxWt5pHJkiMO7_R5fbhQ",
			# "expiry"=>"1455228520",
			# "uid"=>"a@hi.com"}
	end

	describe 'registration' do

		it 'create user' do
			post '/auth', { email: 'a@hi.com', password: 'bfwfewfewfrwf', password_confirmation: 'bfwfewfewfrwf' }
			expect_json status: 'success'
		end

		it 'delete user' do
			delete '/auth', { uid: @user.uid }, @auth_headers
			expect_json status: 'success', message: /has been destroyed/
		end

	end

	it 'sign in' do
		post '/auth/sign_in', { email: @user.email, password: @user.password }
		expect_json({:data=>{:provider=>"email", :uid=>@user.email, :email=>@user.email}})
		expect_status 200
	end

	it 'sign out' do
		delete '/auth/sign_out', @auth_headers
		expect_json success: true
		expect_status 200
	end













end
