require 'rails_helper'

resource 'Categories', type: :request do

	before(:all) do
		@category = FactoryGirl.create_list :category, 3
	end


	get '/categories' do
		parameter :city_id,  'get categories that have products with :city_id'
		parameter :in_stock, 'get categories that have products :in_stock'

		example_request 'get all categories' do
			returned_ids = jsons.pluck(:id)
			expected_ids = Category.pluck(:id)

			expect(returned_ids).to match_array(expected_ids)
			expect(status).to eq(200)
		end

		it 'get filtered categories', document: false do
			get '/categories?city_id=1&in_stock=false'
			expect_status 200
		end

	end


end
