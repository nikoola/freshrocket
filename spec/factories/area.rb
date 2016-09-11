FactoryGirl.define do 
	factory :area do
		association :city
		transient do
			radius_km 5
			#city  {FactoryGirl.create :city}
		end
		
		radius {radius_km}
		lat 0
		lng 0

		callback(:before_create, :after_build) do |area, evaluator|
			# binding.pry
			 # byebug
			res = Geokit::Geocoders::GoogleGeocoder.geocode evaluator.city.name
			unless res.success
				#errors.add :geocode, "GeoCoding Failure"
				puts "error in Geokit"
				# byebug
				binding.pry
				exit
			end
			#area.city = city
			area.lat, area.lng = res.lat, res.lng
			area.name = res.full_address
			#area.city = evaluator.city
			#puts res
			#byebug
		end
		after(:create) do |area, evaluator|
			area.save
		end
	end
end