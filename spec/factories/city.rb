FactoryGirl.define do
	factory :city do
		sequence(:name) { |i| "New York #{i}" }
	end
end
