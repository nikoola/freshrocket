require 'rails_helper'

resource 'admin: products', type: :request do

	let(:city)           { FactoryGirl.create :city }
	let(:valid_params)   { {title: 'fish', price: '3.0', inventory_count: 2, city_id: city.id} }
	let(:invalid_params) { {title: 'fish', price: nil} } #price: nil is so that it's invalid on update

	let(:user) { FactoryGirl.create :user, abilities: [:products, :users, :cities] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:product) { FactoryGirl.create :product }
	let(:product_not_in_stock) { FactoryGirl.create :product, inventory_count: 0 }


	post '/admin/products' do
		with_options scope: :product do
			parameter :title, '', required: true
			parameter :price, '', required: true
			parameter :inventory_count, 'amount of product in stock', required: true
			parameter :city_id, 'product served at city', required: true
			parameter :image
			parameter :category_ids, 'array of ids of categories product belongs to'
			parameter :description
		end

		example 'create product' do
			category = FactoryGirl.create :category
			do_request( product: valid_params.merge(category_ids: [category.id]) )

			product = Product.find(json[:id])

			expect(status).to eq(201)
			expect(json.keys).to include :id, :title, :price, :created_at, :updated_at, :inventory_count, :image_url
			expect(product.categories.pluck(:id)).to match_array category.id
		end

		it 'params wrapping', document: false do
			category = FactoryGirl.create :category
			headers = auth_headers.merge('ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json')

			post '/admin/products', { 
				"title": "fish",
				"price": "3.0",
				"inventory_count": 2,
				"city_id": FactoryGirl.create(:city).id, 
				category_ids: [category.id] 
			}.to_json, headers

			product = Product.find(json_body[:id])

			expect_status 201
			expect(product.categories.pluck(:id)).to match_array category.id
		end



		example 'create product: invalid params', document: false do
			product = Product.new invalid_params

			do_request({ product: invalid_params })

			expect(status).to eq(422)
			expect(json).to include({:price=>["can't be blank"]})
		end

		it 'creates product with image', document: false do
			binding.pry
			# image = "#{Rails.root}/spec/files/hi.jpg"
			# file = Rack::Test::UploadedFile.new image, "image/jpeg"
			# valid_params_with_image = valid_params.merge({image: file})

			# post admin_products_path, { product: valid_params_with_image }, auth_headers

			# product = Product.last
			# expect(product.image.url).to eq("/uploads/product/image/#{product.id}/hi.jpg")

			# FileUtils.rm_rf(Rails.root.to_s + '/public/uploads/product/image/#{product.id}')
		end
	end

	put '/admin/products/:id' do

		example 'update product' do
			do_request({ 
				id: product.id, 
				product: { 
					title: 'hi' 
				} 
			})

			expect(status).to eq(200)
		end

		example 'update product: invalid_params' do
			do_request({ 
				id: product.id, 
				product: {
					title: nil 
				}
			})

			expect(status).to eq(422)
		end
	end

	delete '/admin/products/:id' do
		example 'delete product' do
			explanation "deletes product if it's not in any order, disables it (inventory_count: 0) otherwise"
			do_request(id: product.id)
			
			expect(status).to eq(200)
			expect(Product.find_by(id: product.id)).to be_nil
		end

		it 'disable product', document: false do
			product_in_order = FactoryGirl.create(:order).line_items.first.product
			do_request(id: product_in_order.id)

			expect(status).to eq(200)
			expect(Product.find_by(id: product_in_order.id).inventory_count).to eq(0)
		end

	end


end
