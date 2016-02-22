FactoryGirl.define do

	factory :user do
		sequence(:email)       { |i| i.to_s + Faker::Internet.email }
		password              'secrety_bickety'
		password_confirmation 'secrety_bickety'
		first_name             { Faker::Name.first_name }
		last_name              { Faker::Name.last_name }

		sequence(:phone)       { |i| "+7917#{rand(100000..999999)}#{i.to_s[0]}" }

		transient do
			abilities           []
		end

		after(:create) do |user, evaluator|
			evaluator.abilities.each do |ability|
				user.add_ability ability
			end
			user.save; user.reload
		end

	end


	factory :verified_user, parent: :user do
		after(:create) do |user, evaluator|
			user.save
			user.update(is_verified: true)
		end
	end
end
