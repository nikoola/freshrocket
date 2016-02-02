require 'rails_helper'

RSpec.describe 'Products', type: :request do

	let(:valid_params)   { {title: 'fish', price: '3.0', inventory_count: 2, city_id: 1} }
	let(:invalid_params) { {title: 'fish', price: nil} } #price: nil is so that it's invalid on update

	before(:all) do
		@admin_user = FactoryGirl.create :user, abilities: [:products, :users]
		@admin_user_auth_headers = @admin_user.create_new_auth_token
	end

	before(:each) do
		@product = FactoryGirl.create :product
		@product_not_in_stock = FactoryGirl.create :product, inventory_count: 0
	end



	describe 'POST admin/products' do
		it 'with valid params: creates product' do
			post admin_products_path, { product: valid_params }, @admin_user_auth_headers
			expect_json valid_params
		end

		it 'with invalid params' do
			product = Product.new invalid_params
			post admin_products_path, { product: invalid_params }, @admin_user_auth_headers

			expect_json product.errors.messages
		end

		it 'creates product with image' do
			image = '/home/lakesare/Desktop/rivo/spec/files/hi.jpg'
			file = Rack::Test::UploadedFile.new image, "image/jpeg"
			valid_params_with_image = valid_params.merge({image: file})

			post admin_products_path, { product: valid_params_with_image }, @admin_user_auth_headers

			product = Product.last
			path_to_image = "/uploads/product/image/#{product.id}/hi.jpg"
			expect(product.image.url).to eq(path_to_image)

			FileUtils.rm_rf(Rails.root.to_s + '/public/uploads/product/image/#{product.id}')
		end
	end

	describe 'PATCH/PUT admin/products/1' do
		it 'with valid params' do
			put admin_product_path(@product), { product: valid_params }, @admin_user_auth_headers
			expect_status 200
		end

		it 'with invalid_params' do
			product = Product.new invalid_params

			put admin_product_path(@product), { product: invalid_params }, @admin_user_auth_headers
			expect_json product.errors.messages
		end
	end

	it 'DELETE admin/products/1' do
		delete admin_product_path(@product), @admin_user_auth_headers
		expect(response.status == 200)
	end








end
