require 'rails_helper'

describe 'Google place' do


	it '?' do
		# polygon = Geokit::Polygon.new([ 
		# 	Geokit::LatLng.new(0, 0), 
		# 	Geokit::LatLng.new(10, 0),
		# 	Geokit::LatLng.new(0, 20)
		# ])

		# point = Geokit::LatLng.new(5, 500)
		# expect(polygon.contains?(point)).to be falseRails.application.secrets['google_place_api_key']
		client =  GooglePlacesAutocomplete::Client.new(:api_key => Rails.application.secrets['google_place_api_key'])
		autocomplete = client.autocomplete(:input => "paris", :types => "geocode",
		 :lat => 40.606654, :lng => 14.036865, :radius => 0, :components => 'country:in')
		# unless autocomplete[:predictions].count
		# 	exit
		# end
		# binding.pry
		res = []
		autocomplete.parsed_response["predictions"].each { |x|
			# binding.pry
				details = client.details(:placeid => x["place_id"])
				details = details["result"]
				# binding.pry
			# one = []
			formatted_add = details["formatted_address"]
			lat = details["geometry"]["location"]["lat"]
			lng = details["geometry"]["location"]["lng"]
			one = {:address => formatted_add, :lat => lat, :lng => lng}
			res << one
		}
		puts res
		
		binding.pry
		# puts autocomplete.parsed_response["predictions"].first["description"]
	end
end



