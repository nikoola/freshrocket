require 'rails_helper'

resource 'cities', type: :request do


	get '/cities' do
		parameter :active,  '1/0 get cities marked as active'

		example 'get all cities with their areas' do
			FactoryGirl.create_list :city, 3
			FactoryGirl.create_list :city, 2, active: false
			City.first.areas << FactoryGirl.create(:area)

			do_request active: '1'

			returned_ids = jsons.pluck(:id)
			expected_ids = City.where(active: true).pluck(:id)

			expect(returned_ids).to match_array(expected_ids)
			expect(status).to eq(200)

			expect(jsons[0]).to include :areas
		end
	end

	get '/cities/:id' do
		example 'get city with its areas' do
			city = FactoryGirl.create :city
			FactoryGirl.create_list :area, 3, city_id: city.id

			do_request id: city.id

			expect(json[:areas][0]).to include :id, :name
			expect(status).to eq(200)
		end

	end


end











