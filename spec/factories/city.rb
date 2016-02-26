FactoryGirl.define do
	factory :city do
		sequence(:name) { |i| Faker::Address.city + '_' + i.to_s }
	end
end
