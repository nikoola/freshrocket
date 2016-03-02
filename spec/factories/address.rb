FactoryGirl.define do
	factory :address do
		association :user
		address     { Faker::Address.street_address }
		association :city


	end
end
