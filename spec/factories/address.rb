FactoryGirl.define do
	factory :address do
		association             :user
		association             :city
		association 			:area
		
		transient do
			
		end
		trait :associations do
			city_id 1
			user_id 1
			area_id 1
		end
		door_number             '5'
		callback(:after_build, :before_create) do |address, evaluator|
			# byebug
			# binding.pry
			res = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{evaluator.area.lat+0.00001*rand()},#{evaluator.area.lng+0.00001*rand()}"
			# byebug
			address.lat = res.lat
			address.lng = res.lng
			address.stringified_coordinate = [res.lat, res.lng].to_s
			address.city = evaluator.area.city
			address.street_and_house = res.full_address
			#byebug
		end
		after(:create) do |address, evaluator|
			address.save
		end
	end
end
