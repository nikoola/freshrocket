require 'rails_helper'

RSpec.describe 'Products', type: :request do

	let(:valid_params)   { {title: 'fish', price: '3.0', inventory_count: 2, city_id: 1} }
	let(:invalid_params) { {title: 'fish', price: nil} } #price: nil is so that it's invalid on update


	before(:each) do
		@city = City.create name: 'New York'
		City.create name: 'Amsterdam'

		@product = Product.create valid_params

		@product_not_in_stock = Product.create(valid_params)
		@product_not_in_stock.update inventory_count: 0
	end

	describe 'GET /products' do
		it 'with no params' do
			get products_path

			titles_from_json = json_body.map {|a| a[:title]}
			titles_from_db   = Product.pluck(:title)

			expect(titles_from_json).to eq(titles_from_db)
		end

		it '?city_id=1' do
			get products_path, { city_id: 1 }

			city_ids_from_json = json_body.map { |a| a[:city_id] }
			expect(city_ids_from_json.all? { |id| id == 1 })
		end

		it '?city_id=1&in_stock=true' do
			get products_path, { city_id: 1, in_stock: true }

			city_ids_from_json = json_body.map { |a| a[:city_id] }
			expect(city_ids_from_json.all? { |id| id == 1 })

			inventory_count_from_json = json_body.map { |a| a[:inventory_count] }
			expect(inventory_count_from_json.all? { |id| id > 0 })

			amount_of_records_in_response = json_body.count

			expect(amount_of_records_in_response).to eq(Product.city_id(1).in_stock(true).count)
		end

	end


	it 'GET /products/1' do
		get product_path(@product)
		expect_json valid_params
	end


	describe 'POST /products' do
		it 'with valid params' do
			post products_path, { product: valid_params } 
			expect_json valid_params
		end

		it 'with invalid params' do
			product = Product.new invalid_params
			post products_path, { product: invalid_params } 

			expect_json product.errors.messages
		end
	end

	describe 'PATCH/PUT /products/1' do
		it 'with valid params' do
			put product_path(@product), { product: valid_params } 
			expect(response.status == 200) #yes, I know about have_http_status(200). I just prefer this one.
		end

		it 'with invalid_params' do
			product = Product.new invalid_params

			put product_path(@product), { product: invalid_params } 
			expect_json product.errors.messages
		end
	end

	it 'DELETE /products/1' do
		delete product_path(@product)
		expect(response.status == 200)
	end








end
