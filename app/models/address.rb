class Address < ActiveRecord::Base
#from api at least -> city_id, user_id, door_number,
	belongs_to :user, :inverse_of => :addresses
	belongs_to :city#, though: :area
	belongs_to :area
	has_many   :orders

	validates_presence_of :user,
		:city, :street_and_house, :door_number, :lat, :lng
	# before_validation :reverse_geocode
	scope :active, -> (bool) { where active: param_to_bool(bool) }

	include Filterable
	
	def stringified_coordinate= string
		self.lat, self.lng = JSON.parse(string)
	end
	def destroy_or_disable
		self.orders.any? ? disable : destroy
	end
	def self.get_address_by_city_id(city_id)
		self.where(city_id: city_id).first
	end
	private
		def disable
			update active: false
		end
		# def reverse_geocode
		# 	# byebug
		# 	binding.pry
		# 	res=Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{self.lat},#{self.lng}"#warning:no return state check!
		# 	# => #<Geokit::GeoLoc:0x558ed0 ...
		# 	# res.full_address "101-115 Main St, San Francisco, CA 94105, USA"
		# 	#street_and_house = res.street_address
		# 	#door_number = 5
		# end

end
 