require 'rails_helper'

resource 'cities', type: :request do


	get '/categories' do
		parameter :city_id,  'get categories that have products with :city_id'

		example 'get all categories' do
			city = FactoryGirl.create :city
			product = FactoryGirl.create :product, city_id: city.id

			category = FactoryGirl.create :category
			category.products = [product]
			category.save!

			FactoryGirl.create_list :category, 3

			do_request city_id: city.id

			returned_ids = jsons.pluck(:id)
			expected_ids = [category.id]

			expect(returned_ids).to match_array(expected_ids)
			expect(status).to eq(200)
		end


	end


end
