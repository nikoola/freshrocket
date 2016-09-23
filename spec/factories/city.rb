FactoryGirl.define do
	factory :city do
		sequence(:name)      { |i| INDIAN_CITIES[i] }
		callback(:before_create, :after_build) do |city, evaluator|
			
			 # byebug
			res1 = Geokit::Geocoders::GoogleGeocoder.geocode evaluator.name
			unless res1.success
				#errors.add :geocode, "GeoCoding Failure"
				puts "error in Geokit"
				# byebug
				binding.pry
				exit
			end
			# binding.pry
			#area.city = city
			city.lat, city.lng = res1.lat, res1.lng
			#geocoding and reverse geocoding returns different city namae ex:) Delhi, New Delhi
			
			# res=Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{res1.lat},#{res1.lng}"   
			# # => #<Geokit::GeoLoc:0x558ed0 ...
			# # res.full_address "101-115 Main St, San Francisco, CA 94105, USA"
			# unless res.success
			# 	puts "No city name"
			# 	binding.pry
			# else
			# 	city.name = res.city
			# end
		end
	end

	factory :same_city, parent: :city do
		name 'New York'
	end
end


