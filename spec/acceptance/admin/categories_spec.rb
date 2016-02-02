require 'rails_helper'

RSpec.describe 'Products', type: :request do

	before(:all) do
		@admin_user = FactoryGirl.create :user, abilities: ['categories']
		@admin_user_auth_headers = @admin_user.create_new_auth_token
	end

	before(:each) do
		@category = FactoryGirl.create :category
	end



	describe 'POST admin/categories' do
		it 'with valid params: creates category' do
			post admin_categories_path, { category: {name: 'breakfasts'} }, @admin_user_auth_headers

			expect_status 201
			expect_json_keys [:id, :name]
			expect_json :name=>"breakfasts"
		end

		it 'with invalid params' do
			post admin_categories_path, { category: {name: nil} }, @admin_user_auth_headers

			expect_json :name=>["can't be blank"]
		end
	end

	describe 'PATCH/PUT admin/categories/1' do
		it 'with valid params' do
			put admin_category_path(@category), { category: {name: 'hollywood'} }, @admin_user_auth_headers
			expect_status 200
			expect_json_keys [:id, :name]
		end

		it 'with invalid_params' do
			put admin_category_path(@category), { category: {name: nil} }, @admin_user_auth_headers
			expect_status 422
			expect_json :name=>["can't be blank"]
		end
	end

	it 'DELETE admin/categories/1' do
		delete admin_category_path(@category), @admin_user_auth_headers
		expect_status 200
	end








end
