require 'rails_helper'

RSpec.describe 'Products', type: :request do

	before(:all) do
		@admin_user = FactoryGirl.create :admin_user
		@admin_user_auth_headers = @admin_user.create_new_auth_token
	end

	before(:each) do
		@product = FactoryGirl.create :product
		@product_not_in_stock = FactoryGirl.create :product, inventory_count: 0
	end

	describe 'GET /products' do
		context 'admin' do
			it 'with no params' do
				get orders_path, {}, @admin_user_auth_headers

				ids_from_json = json_body.map {|a| a[:id]}
				ids_from_db   = Order.pluck(:id)

				expect(ids_from_json).to eq(ids_from_db)
			end


		end

		# it '?city_id=1' do
		# 	get products_path, { city_id: 1 }

		# 	city_ids_from_json = json_body.map { |a| a[:city_id] }
		# 	expect(city_ids_from_json.all? { |id| id == 1 })
		# end

		# it '?city_id=1&in_stock=true' do
		# 	get products_path, { city_id: 1, in_stock: true }

		# 	city_ids_from_json = json_body.map { |a| a[:city_id] }
		# 	expect(city_ids_from_json.all? { |id| id == 1 })

		# 	inventory_count_from_json = json_body.map { |a| a[:inventory_count] }
		# 	expect(inventory_count_from_json.all? { |id| id > 0 })

		# 	amount_of_records_in_response = json_body.count

		# 	expect(amount_of_records_in_response).to eq(Product.city_id(1).in_stock(true).count)
		# end

	end







end
