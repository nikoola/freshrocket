class Address < ActiveRecord::Base

	belongs_to :user
	belongs_to :city
	has_many   :orders

	validates_presence_of :user,
		:city, :street_and_house, :door_number

	validate :has_no_approved_orders?, on: :update
	validate :is_in_deliverable_area?, if: -> { city }

  before_validation :set_coordinate

	include Filterable
	scope :active, -> (bool) { where active: param_to_bool(bool) }

	serialize :coordinate, Array

	def is_in_deliverable_area?
		unless city.contains_coordinate? coordinate
			errors.add :coordinate, 'is not deliverable'
		end
	end


	def stringified_coordinate= string
		self.coordinate = JSON.parse(string)
	end

	def destroy_or_disable
		self.orders.any? ? disable : destroy
	end

	def self.get_address_by_city_id(city_id)
		self.where(city_id: city_id).first
	end

	private

		def set_coordinate
			full_address = "#{self.city.name}, #{street_and_house}"
			self.coordinate = [Geokit::Geocoders::MultiGeocoder.geocode(full_address).lat, Geokit::Geocoders::MultiGeocoder.geocode(full_address).lng]
		end

		def disable
			update active: false
		end

		def has_no_approved_orders?
			if self.orders.any? { |order| order.approved? }
				errors.add 'address', "can't be changed after some approved order uses it"
			end
		end



end
