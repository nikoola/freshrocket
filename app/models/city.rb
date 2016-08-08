class City < ActiveRecord::Base

	has_many :products

	validates :name, presence: true, uniqueness: true
	validates_presence_of :polygon

	include Filterable
	scope :active, -> (bool) { where active: param_to_bool(bool) }
	scope :containing_coordinate, -> (coordinate) {
		select do |city|
			city.contains_coordinate? coordinate
		end
	}


	serialize :polygon, Array



	def geokited_polygon
		array_of_coordinates = polygon.map { |lat, lng| Geokit::LatLng.new(lat, lng) }
		Geokit::Polygon.new array_of_coordinates
	end

	def contains_coordinate? coordinate # [10, 40]
		lat, lng = coordinate.map(&:to_f)
		geokited_lat_lng = Geokit::LatLng.new(lat, lng) #to_i because params turn into ['4', '6']
		geokited_polygon.contains? geokited_lat_lng
	end

	def stringified_polygon= string
		self.polygon = JSON.parse(string)
	end



	def destroy_or_disable
		self.products.any? ? disable : destroy
	end



	private
		def disable
			update active: false
		end







		



end
