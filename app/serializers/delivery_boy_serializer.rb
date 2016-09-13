class DeliveryBoySerializer < ActiveModel::Serializer
	attributes :id, :user_id,
		:current_order_id, :status

	belongs_to :user
end
