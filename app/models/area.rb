class Area < ActiveRecord::Base
	#based on reverse_Geocode -> get other info by reverse_geocode
	belongs_to :city
	has_many :addresses

	validates_presence_of :radius, :name, :lat, :lng, :city

	# before_validation :reverse_geocode
	scope :containing_coordinate, -> (coordinate) {
		select do |area|
			area.contains_coordinate? coordinate
		end.count
	}
	scope :containing_name, -> (text) { where("name like ?", "%#{text}%") }
	scope :active, -> (bool) { where active: param_to_bool(bool) }
	scope :city_id, -> (city_id) { where city_id: city_id }
	
	include Filterable

	def contains_coordinate? coordinate # [10, 40]
		# byebug
		compared_lat, compared_lng = coordinate.map(&:to_f)
		compared_lat_lng = Geokit::LatLng.new(compared_lat, compared_lng) #to_i because params turn into ['4', '6']
		# geokited_polygon.contains? geokited_lat_lng
		area_lat_lng = Geokit::LatLng.new(lat, lng)
		area_lat_lng.distance_to(compared_lat_lng) < radius

	end
	def destroy_or_disable
		self.addresses.any? ? disable : destroy
	end
	def stringified_coordinate= string
		self.lat, self.lng = JSON.parse(string)
	end
	
	private 
		def disable
			update active: false
		end
		def reverse_geocode
			# res=Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{lat},#{lng}"    #warning:no return state check!
			# # => #<Geokit::GeoLoc:0x558ed0 ...
			# # res.full_address "101-115 Main St, San Francisco, CA 94105, USA"
			# unless res.success
			# 	errors.add :city_name, "City and Area City name not matching #{res.city} : #{city.name}"
			# end
			# name = res.full_address


		end
	end
