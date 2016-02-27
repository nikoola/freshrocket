class AddressSerializer < ActiveModel::Serializer
	attributes :id, 
		:address, 
		:city_id, :user_id

end
