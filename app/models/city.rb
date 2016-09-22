class City < ActiveRecord::Base

	has_many :products

	validates :name, presence: true, uniqueness: true
	validates_presence_of :lat, :lng
	scope :active, -> (bool) { where active: param_to_bool(bool) }
	scope :starts_with, -> (name) { where name: name.to_s }		#name is keyword so it is failing to City.send(:name) while using Filterable

	scope :containing_coordinate, -> (coordinate, radius) {
		select do |city|
			city.contains_coordinate? coordinate,radius
		end
	}
	include Filterable

	def destroy_or_disable
		self.products.any? ? disable : destroy
	end

	def stringified_coordinate= string
		self.lat, self.lng = JSON.parse(string)
	end
	def contains_coordinate? coordinate, radius=100 # [10, 40]
		# byebug
		compared_lat, compared_lng = coordinate.map(&:to_f)
		compared_lat_lng = Geokit::LatLng.new(compared_lat, compared_lng) #to_i because params turn into ['4', '6']
		# geokited_polygon.contains? geokited_lat_lng
		area_lat_lng = Geokit::LatLng.new(self.lat, self.lng)
		area_lat_lng.distance_to(compared_lat_lng) < radius

	end

	private
		def disable
			update active: false
		end

end
