require 'rails_helper'

RSpec.describe "Users", type: :request do


	before(:all) do
		@user = FactoryGirl.create :user
		@auth_headers = @user.create_new_auth_token

		@user_with_users_ability = FactoryGirl.create :user, abilities: [:users]
		@auth_headers_with_users_ability = @user_with_users_ability.create_new_auth_token #as if we signed in and remembered them already
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

			get admin_users_path, {}, @auth_headers_with_users_ability
			
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
			get admin_user_path(@user), {}, @auth_headers_with_users_ability
			expect_status 200
		end
	end

	describe 'POST admin/users' do

		it 'by admin, with valid params: user created' do
			post admin_users_path, {user: FactoryGirl.attributes_for(:user)} , @auth_headers_with_users_ability
			expect_status 201
			expect_json_keys :id, :provider, :uid, :email, :phone, :role, :created_at, :updated_at
		end

		it 'by admin, with invalid params: errors returned' do
			post admin_users_path, {user: FactoryGirl.attributes_for(:user, phone: nil)} , @auth_headers_with_users_ability
			expect_status 422
			expect_json :phone=>["can't be blank"]
		end

	end

	describe 'PUT admin/users/1' do
		it 'by admin, with valid params: user updated' do
			put admin_user_path(@user), {user: {role: :admin}}, @auth_headers_with_users_ability
			expect_status 200
		end
	end

	describe 'DELETE admin/users/1' do
		it 'by admin: user deleted' do
			delete admin_user_path(@user), {}, @auth_headers_with_users_ability
			expect_status 200
		end
	end




	describe 'GET admin/users/1/list_abilities' do
		it 'returns resources first user can and cant edit' do
			@user.ability_list = ['users']
			@user.save; @user.reload; #only appears on reload in .abilities list
			get "/admin/users/#{@user.id}/list_abilities", {}, @auth_headers_with_users_ability
			expect_json({:abilities=>{:orders=>0, :products=>0, :users=>1}})
		end
	end


	describe 'PUT admin/users/1/update_abilities' do
		describe 'user with :users ability' do
			it 'with valid params: updates abilities' do
				put "/admin/users/#{@user.id}/update_abilities", {abilities: {'users' => 1, 'products' => 0, 'orders' => 0}}, @auth_headers_with_users_ability
				expect(@user.abilities.map(&:name)).to match_array(['users'])
			end

			it 'with invalid params: returns errors' do
				put "/admin/users/#{@user.id}/update_abilities", {abilities: {'lalala' => 1}}, @auth_headers_with_users_ability

				expect_status 422
				expect_json :abilities=>["lalala is not a valid ability"]
			end
		end

		describe 'user without :users ability' do
			it 'with valid params' do
				put "/admin/users/#{@user.id}/update_abilities", {abilities: {'users' => 1, 'products' => 0, 'orders' => 0}}, @auth_headers
				expect_status 401
			end
		end
	end

end








