FactoryGirl.define do
	factory :city do
		sequence(:name) { |i| Faker::Address.city + '_' + i.to_s }
	end

	factory :same_city, parent: :city do
		name 'New York'
	end
end
