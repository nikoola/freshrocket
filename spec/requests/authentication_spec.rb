require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
	before(:all) do
		@user = FactoryGirl.create :user

		@auth_headers = @user.create_new_auth_token #sign in returns auth headers too.
			# {"access-token"=>"0C887ZJBsQDhbvtUBJGRCw",
			# "token-type"=>"Bearer",
			# "client"=>"GezxWt5pHJkiMO7_R5fbhQ",
			# "expiry"=>"1455228520",
			# "uid"=>"a@hi.com"}
	end


	it 'sign in' do
		post '/auth/sign_in', { email: @user.email, password: @user.password }

		expect_json({:data=>{:provider=>"email", :uid=>@user.email, :email=>@user.email}})
		expect_status 200

		expect(response.headers).to include("access-token", "token-type", "client", "expiry", "uid")
	end

	it 'sign out' do
		delete '/auth/sign_out', @auth_headers
		expect_json success: true
		expect_status 200
	end













end
