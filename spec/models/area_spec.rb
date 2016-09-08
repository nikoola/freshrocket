require 'rails_helper'

RSpec.describe Area, type: :model do

  before(:each) do
    city = FactoryGirl.create :city
  	@area = FactoryGirl.create :area, radius_km: 5,city_id: city.id#can pass city as a param
  end
  
  describe "City name matches area.City name(Reverse Geocoding)" do
  	it "is an example" do
  		@area.save
  		expect(@area.name).to be_a String
  		puts @area.name
  	end
  	it "contains coordinate" do
  		#@area.save
  		# res = Area.within(@area.radius, :origin => @area.name)
  		res = Area.containing_coordinate [@area.lat, @area.lng]
  		#puts res
  		expect(res).to be_a Object

  	end

  end

end
