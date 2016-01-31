require 'rails_helper'

RSpec.describe "Users", type: :request do


	before(:all) do
		@order = FactoryGirl.create :order

		@user = FactoryGirl.create :user
		@auth_headers = @user.create_new_auth_token

		@admin_user = FactoryGirl.create :user, abilities: [:orders]
		@admin_user_auth_headers = @admin_user.create_new_auth_token
	end

	before(:each) do
		@user = FactoryGirl.create :user
		@auth_headers = @user.create_new_auth_token #as if we signed in and remembered them already
	end


	describe 'GET admin/orders' do
		it 'nonauthenticated - 401' do
			get '/admin/orders'
			expect_status 401
		end

		it 'authenticated :client user - 401' do
			get '/admin/orders', {}, @auth_headers
			expect_status 401
		end

		it 'authenticated :admin user - 200' do
			get '/admin/orders', {}, @admin_user_auth_headers
			
			expect_status 200

			returned_ids = json_body.map { |a| a[:id] }
			expect(returned_ids).to eq(Order.pluck(:id))
		end
	end

	describe 'GET admin/orders/1' do
		let(:another_user_auth_headers) { FactoryGirl.create(:user).create_new_auth_token }

		it 'nonauthenticated - 401' do
			get admin_order_path(@order)
			expect_status 401
		end

		it 'authenticated :client user - 401' do
			get admin_order_path(@order), {}, @auth_headers
			expect_status 401
		end

		it 'authenticated :admin user - 200' do
			get admin_order_path(@order), {}, @admin_user_auth_headers
			
			expect_status 200
		end
	end

	describe 'POST admin/orders' do

		it 'by admin, with invalid params: errors returned' do
			post '/admin/orders', {order: FactoryGirl.attributes_for(:order, phone: nil)} , @admin_user_auth_headers
			expect_status 422
			expect_json :user=>["can't be blank"], :order=>["must add at least one line item"]
		end

	end

	describe 'PUT admin/orders/1' do
		it 'by admin, with valid params: user updated' do
			put admin_order_path(@order), {order: {role: :admin}}, @admin_user_auth_headers

			expect_status 200
			expect_json_keys [:status, :comment]
		end
	end

	describe 'DELETE admin/orders/1' do
		it 'by admin: user deleted' do
			delete admin_order_path(@order), {}, @admin_user_auth_headers
			expect_status 200
		end
	end



end
