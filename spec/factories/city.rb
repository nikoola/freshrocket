FactoryGirl.define do
	factory :city do
		sequence(:name) { |i| Faker::Address.city }
	end
end
