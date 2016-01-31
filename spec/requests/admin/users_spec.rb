require 'rails_helper'

RSpec.describe "Users", type: :request do


	before(:all) do
		@admin_user = FactoryGirl.create :admin_user
		@admin_user_auth_headers = @admin_user.create_new_auth_token
	end

	before(:each) do
		@user = FactoryGirl.create :user
		@auth_headers = @user.create_new_auth_token #as if we signed in and remembered them already
	end


	describe 'GET admin/users' do
		it 'nonauthenticated - 401' do
			get admin_users_path
			expect_status 401
		end

		it 'authenticated :client user - 401' do
			get admin_users_path, {}, @auth_headers
			expect_status 401
		end

		it 'authenticated :admin user - 200' do
			@user = FactoryGirl.create :admin_user
			get admin_users_path, {}, @user.create_new_auth_token
			
			expect_status 200

			returned_ids = json_body.map { |a| a[:id] }
			expect(returned_ids).to eq(User.pluck(:id))
		end
	end

	describe 'GET admin/users/1' do
		let(:another_user_auth_headers) { FactoryGirl.create(:user).create_new_auth_token }

		it 'nonauthenticated - 401' do
			get admin_user_path(@user)
			expect_status 401
		end

		it 'authenticated :client user - 401' do
			get admin_user_path(@user), {}, @auth_headers
			expect_status 401
		end

		it 'authenticated :admin user - 200' do
			@user = FactoryGirl.create :admin_user
			get admin_user_path(@user), {}, @user.create_new_auth_token
			
			expect_status 200
		end
	end

	describe 'POST admin/users' do

		it 'by admin, with valid params: user created' do
			post admin_users_path, {user: FactoryGirl.attributes_for(:user)} , @admin_user_auth_headers
			expect_status 201
			expect_json_keys :id, :provider, :uid, :email, :phone, :role, :created_at, :updated_at
		end

		it 'by admin, with invalid params: errors returned' do
			post admin_users_path, {user: FactoryGirl.attributes_for(:user, phone: nil)} , @admin_user_auth_headers
			expect_status 422
			expect_json :phone=>["can't be blank"]
		end

	end

	describe 'PUT admin/users/1' do
		it 'by admin, with valid params: user updated' do
			put admin_user_path(@user), {user: {role: :admin}}, @admin_user_auth_headers
			expect_status 200
		end

		# it 'admin can update other user roles to admin'
	end

	describe 'DELETE admin/users/1' do
		it 'by admin: user deleted' do
			delete admin_user_path(@user), {}, @admin_user_auth_headers
			expect_status 200
		end
	end



end
