require 'rails_helper'

resource 'products', type: :request do

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

		@product = FactoryGirl.create(:product)
	end


	get '/products' do
		parameter :city_id
		parameter :category_id
		parameter :in_stock, '1/0, if absent will return all'

		example_request 'get all products' do
			explanation 'returns all products with no params'
			returned_ids = jsons.pluck(:id)
			expected_ids = Product.pluck(:id)

			expect(returned_ids).to match_array(expected_ids)
			expect(status).to eq(200)
		end


		it 'get filtered products' do
			explanation 'returns all products with inventory count > 0, and from specific category'
			do_request category_id: @category_2.id, in_stock: 1

			returned_ids = jsons.pluck(:id)
			expected_ids = Product.select do |product|
				product.inventory_count > 0 and product.categories.any?{ |category|
					category.id == @category_2.id
				}
			end.pluck(:id)

			expect(returned_ids).to match_array(expected_ids)
			expect(status).to eq(200)
		end

		it 'returns all products from specific city', document: false do
			do_request city_id: @city_1.id

			returned_ids = jsons.pluck(:id)
			expected_ids = Product.where(city_id: @city_1.id).pluck(:id)

			expect(returned_ids).to match_array(expected_ids)
			expect(status).to eq(200)
		end

	end


	get '/products/:id' do
		let(:id) { @product.id }

		example_request 'get product' do
			expect(json).to include(:id, :title, :price, :created_at, :updated_at, :inventory_count, :city_id)
		  expect(status).to eq(200)
		end
	end


end
