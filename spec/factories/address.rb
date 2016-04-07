FactoryGirl.define do
	factory :address do
		association             :user
		association             :city
		street_and_house        { Faker::Address.street_address }
		stringified_coordinate  CITY_POLYGON[:coordinate].to_s
		door_number             '5'
	end
end
