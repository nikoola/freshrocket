require 'rails_helper'

RSpec.describe 'Products', type: :request do

	let(:valid_params)   { {title: 'fish', price: '3.0', inventory_count: 2, city_id: 1} }
	let(:invalid_params) { {title: 'fish', price: nil} } #price: nil is so that it's invalid on update

	before(:each) do
		@product = FactoryGirl.create :product
		@product_not_in_stock = FactoryGirl.create :product, inventory_count: 0
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
		expect_status 200
		expect_json_keys [:id, :title, :price, :created_at, :updated_at, :image_file_name, :image_content_type, :image_file_size, :image_updated_at, :inventory_count, :city_id]
	end


end
