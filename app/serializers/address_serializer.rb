class AddressSerializer < ActiveModel::Serializer
	attributes :id, 
		:city_id, :user_id,
		:street_and_house, :door_number, :active,
		:city_name

	def city_name
		object.city.name
	end

end
