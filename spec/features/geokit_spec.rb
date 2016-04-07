require 'rails_helper'

describe 'Geokit' do


	it 'polygon.contains?' do
		polygon = Geokit::Polygon.new([ 
			Geokit::LatLng.new(0, 0), 
			Geokit::LatLng.new(10, 0),
			Geokit::LatLng.new(0, 20)
		])

		point = Geokit::LatLng.new(5, 500)
		expect(polygon.contains?(point)).to be false
	end




end






