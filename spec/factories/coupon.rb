FactoryGirl.define do
	factory :coupon do

		name            'red'
		sequence(:code) { |i| "#{rand(1000..9999)}#{i}" }
		discount        { rand(0..100) }


	end
end
