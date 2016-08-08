class LineItemSerializer < ActiveModel::Serializer
	attributes :id, 
		:order_id,
		:amount, :fixed_price, :product_id, :option_id

	has_one :product
end
