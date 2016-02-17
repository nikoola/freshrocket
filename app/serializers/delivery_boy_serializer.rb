class DeliveryBoySerializer < ActiveModel::Serializer
	attributes :id, 
		:user_id,
		:lat, :long,
		:status
end
