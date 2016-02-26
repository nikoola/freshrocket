FactoryGirl.define do
	factory :area do
		association :city
		sequence(:name) { |i| Faker::Address.city + '_area_' + i.to_s }
	end
end
