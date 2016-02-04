FactoryGirl.define do

	factory :user do
		sequence(:email)       { |i| i.to_s + Faker::Internet.email }
		password              'secrety_bickety'
		password_confirmation 'secrety_bickety'

		phone                 { Faker::PhoneNumber.cell_phone }

		transient do
			abilities           []
		end

		after(:create) do |user, evaluator|
		  user.ability_list = evaluator.abilities
		  user.save; user.reload
		end



	end
end
