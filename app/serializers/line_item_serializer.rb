class LineItemSerializer < ActiveModel::Serializer
	attributes :id, 
		:order_id, :product_id,
		:amount, :fixed_price
end
