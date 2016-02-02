require 'rails_helper'

RSpec.describe 'Products', type: :request do

	before(:all) do
		@city_1, @city_2 = FactoryGirl.create_list :city, 2
		@category_1, @category_2 = FactoryGirl.create_list :category, 2
		FactoryGirl.create_list(:product, 4, city_id: @city_1.id).each do |product|
			product.categories << @category_1
		end
		FactoryGirl.create_list(:product, 3, city_id: @city_2.id).each do |product|
			product.categories << @category_2
		end
		FactoryGirl.create_list(:product, 3, city_id: @city_2.id, inventory_count: 0).each do |product|
			product.categories << @category_2
		end
		FactoryGirl.create_list :product, 5, inventory_count: 0
	end

	describe 'GET /products' do
		it 'with no params' do
			get products_path

			titles_from_json = json_body.map {|a| a[:title]}
			titles_from_db   = Product.pluck(:title)

			expect(titles_from_json).to eq(titles_from_db)
		end

		it '?city_id=1' do
			get products_path, { city_id: @city_1.id }

			city_ids_from_json = json_body.map { |a| a[:city_id] }
			expect(city_ids_from_json.all? { |id| id == @city_1.id })
		end

		it '?category_id=1&in_stock=true' do
			get products_path, { category_id: @category_2.id, in_stock: true }

			category_ids_from_json = json_body.map { |a| a[:category_2] }
			expect(category_ids_from_json.all? { |id| id == @category_2.id })

			inventory_count_from_json = json_body.map { |a| a[:inventory_count] }
			expect(inventory_count_from_json.all? { |id| id > 0 })

			amount_of_records_in_response = json_body.count

			expect(amount_of_records_in_response).to eq(Product.category_id(@category_2.id).in_stock(true).count)
		end

	end


	it 'GET /products/1' do
		@product = FactoryGirl.create(:product)
		get product_path(@product)
		expect_status 200
		expect_json_keys [:id, :title, :price, :created_at, :updated_at, :inventory_count, :city_id]
	end


end
