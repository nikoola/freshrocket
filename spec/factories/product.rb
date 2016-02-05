FactoryGirl.define do
	factory :product do
		title           'fish'
		price           3.0
		inventory_count 20
		association     :city
	end
end
