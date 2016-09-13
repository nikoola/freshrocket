class DeliveryBoySerializer < ActiveModel::Serializer
	attributes :id, :user_id,
		:current_order_id, :status, :user

	def user 
		User.find(object.user_id)
	end
end
