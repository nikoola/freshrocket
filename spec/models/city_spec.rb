require 'rails_helper'


describe City, type: :model do

	let(:city) { FactoryGirl.create :city }

	describe 'name attribute' do

		# it 'is serialized to be an array' do
		# 	expect(city.polygon).to be_an Array
		# end

		# describe '.contains_coordinate?' do
		# 	it 'true' do
		# 		city.update polygon: CITY_POLYGON[:contains_coordinate]
		# 		expect(city.contains_coordinate? CITY_POLYGON[:coordinate]).to be true
		# 	end

		# 	it 'false' do
		# 		city.update polygon: CITY_POLYGON[:doesnt_contain_coordinate]
		# 		expect(city.contains_coordinate? CITY_POLYGON[:coordinate]).to be false
		# 	end
		# end

		# it 'class.containing_coordinate?' do
		# 	FactoryGirl.create :city, polygon: CITY_POLYGON[:doesnt_contain_coordinate]
		# 	FactoryGirl.create_list :city, 2, polygon: CITY_POLYGON[:contains_coordinate]
		# 	expect(City.containing_coordinate(CITY_POLYGON[:coordinate]).count).to eq(2)
		# end
		it 'is a city object create' do
			expect(city.name).to be_an String
			#puts "City name is : #{city.name}" 
		end



	end



end