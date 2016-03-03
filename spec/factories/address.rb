FactoryGirl.define do
	factory :address do
		association      :user
		association      :city
		street_and_house { Faker::Address.street_address }
		door_number      '5'


	end
end
