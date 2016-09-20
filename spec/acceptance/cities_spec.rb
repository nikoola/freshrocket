require 'rails_helper'

resource 'cities', type: :request do


	get '/cities' do
		parameter :active,  '1/0 get cities marked as active'
		

		example 'get all cities' do
			FactoryGirl.create_list :city, 3

			FactoryGirl.create_list :city, 2, active: false

			FactoryGirl.create_list :city, 4


			do_request active: '1'#,name: City.first.name
							
			returned_ids = jsons.pluck(:id)
			expected_ids = City.where(active: true).pluck(:id)

			expect(returned_ids).to match_array(expected_ids)
			#expect(returned_ids.count).to eq(3)
			expect(status).to eq(200)
		end




	end

	get '/cities/:id' do
		example 'get city' do
			city = FactoryGirl.create :city

			do_request id: city.id

			expect(json).to include :id, :name
			expect(status).to eq(200)
		end

	end

	# get '/cities/:id/containing_areas' do
	# 	let(:city)    { FactoryGirl.create :city }
	# 	parameter :id, 'city id'

	# 	example 'get all areas in city', :focus => true do
	# 		FactoryGirl.create_list :area, 3, city_id: city.id, active: false
	# 		FactoryGirl.create_list :area, 2, city_id: city.id

	# 		do_request id: city.id 

	# 		# returned_ids = jsons.pluck(:id)
	# 		# expected_ids = Area.where(active: false).pluck(:id)

	# 		expect(status).to eq(200)
	# 	    returned_ids = jsons.pluck(:id)
	# 		expected_ids = Area.pluck(:id)
	# 		# puts jsons
	# 		expect(returned_ids).to match_array(expected_ids)
	# 	end
	# end

	get '/cities/:id/recommend_areas', focus: true do
		let(:city)    { FactoryGirl.create :city }
		parameter :input, "the keyword"
		parameter :id, "city id"

		example 'get all areas containing delhi using google place api' do
			do_request input: "delhi", id: city.id
			# puts json
			# binding.pry
			expect(jsons).not_to be_nil
		end
	end




end











