require 'rails_helper'

RSpec.describe "Users", type: :request do

	describe "Authentication" do

		let(:valid_params)   { {title: 'fish', price: '3.0', inventory_count: 2, city_id: 1} }

		before(:all) do
			login = FactoryGirl.create :login
			@user = FactoryGirl.create :user

			post '/token', { grant_type: 'password', username: 'a', password: 'b' }
			@access_token = json_body[:access_token]
		end


		it '' do
			get products_path, {}, { :Authorization => "Bearer #{@access_token}"}
			expect_status 200
		end

		it 'with valid params' do
			FactoryGirl.create :city #need to have city before creating product
			post products_path, { product: valid_params } 
			expect_status 401
		end

		it '' do
			@user.role = :admin; @user.save

			post '/token', { grant_type: 'password', username: 'a', password: 'b' }
			@access_token = json_body[:access_token]

			post products_path, { product: valid_params }, { :Authorization => "Bearer #{@access_token}"}
			expect_json valid_params
		end
	






	end
end
