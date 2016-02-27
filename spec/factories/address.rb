FactoryGirl.define do
	factory :address do
		association :user
		association :city
		
		address     { Faker::Address.street_address }
	end
end
