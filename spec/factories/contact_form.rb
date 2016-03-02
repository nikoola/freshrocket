FactoryGirl.define do
	factory :contact_form do
		name    Faker::Name.first_name
		email   Faker::Internet.email

		message Faker::Hacker.say_something_smart

	end
end
