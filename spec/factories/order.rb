FactoryGirl.define do

	factory :order do
		association :user
		status      ''
    fixed_price ''
	end

end
