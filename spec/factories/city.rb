FactoryGirl.define do
	factory :city do
		sequence(:name)      { |i| INDIAN_CITIES[i] }
		callback(:before_create, :after_build) do |city, evaluator|
			
			 # byebug
			res = Geokit::Geocoders::GoogleGeocoder.geocode evaluator.name
			unless res.success
				#errors.add :geocode, "GeoCoding Failure"
				puts "error in Geokit"
				# byebug
				binding.pry
				exit
			end
			# binding.pry
			#area.city = city
			city.lat, city.lng = res.lat, res.lng
			#geocoding and reverse geocoding returns different city namae ex:) Delhi, New Delhi

			res=Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{res.lat},#{res.lng}"   
			# => #<Geokit::GeoLoc:0x558ed0 ...
			# res.full_address "101-115 Main St, San Francisco, CA 94105, USA"
			unless res.success
				errors.add :city_name, "No city name"
			end
		


			if res.city.present?
				city.name = res.city
			end
			#area.city = evaluator.city
			#puts res
			#byebug
		end
	end

	factory :same_city, parent: :city do
		name 'New York'
	end
end


