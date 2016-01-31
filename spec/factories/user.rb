FactoryGirl.define do

	factory :user do
		sequence(:email)       { |i| "hi_#{i}@hi.com" }
		password              'secrety_bickety'
		password_confirmation 'secrety_bickety'

		phone                 '+79173332221'
		role                  :client


		transient do
			abilities           []
		end

		after(:create) do |user, evaluator|
		  user.ability_list = evaluator.abilities
		  user.save; user.reload
		end



	end
end
