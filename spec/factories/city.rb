FactoryGirl.define do
	factory :city do
		sequence(:name)      { |i| INDIAN_CITIES[i] }
		stringified_polygon  CITY_POLYGON[:contains_coordinate].to_s
	end

	factory :same_city, parent: :city do
		name 'New York'
	end
end


