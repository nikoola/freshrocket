require_relative '../files/indian_cities'

FactoryGirl.define do
	factory :city do
		sequence(:name) { |i| INDIAN_CITIES[i] }
	end

	factory :same_city, parent: :city do
		name 'New York'
	end
end
