class LineItemSerializer < ActiveModel::Serializer
	attributes :id, 
		:order_id,
		:amount, :fixed_price

	has_one :product
end
