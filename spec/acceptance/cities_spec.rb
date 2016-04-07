require 'rails_helper'

resource 'cities', type: :request do


	get '/cities' do
		parameter :active,  '1/0 get cities marked as active'
		parameter :containing_coordinate, '[1, 5]'

		example 'get all cities' do
			FactoryGirl.create_list :city, 3, 
				polygon: CITY_POLYGON[:contains_coordinate]

			FactoryGirl.create_list :city, 2, active: false, 
				polygon: CITY_POLYGON[:contains_coordinate]

			FactoryGirl.create_list :city, 4,
				polygon: CITY_POLYGON[:doesnt_contain_coordinate]


			do_request active: '1', 
				containing_coordinate: CITY_POLYGON[:coordinate]

			returned_ids = jsons.pluck(:id)
			expected_ids = City.where(active: true).containing_coordinate(CITY_POLYGON[:coordinate]).pluck(:id)

			expect(returned_ids).to match_array(expected_ids)
			expect(returned_ids.count).to eq(3)
			expect(status).to eq(200)
		end




	end

	get '/cities/:id' do
		example 'get city' do
			city = FactoryGirl.create :city

			do_request id: city.id

			expect(json).to include :id, :name, :polygon
			expect(status).to eq(200)
		end

	end



end











