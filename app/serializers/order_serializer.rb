class OrderSerializer < ActiveModel::Serializer
	attributes :id, :user_id, :status, :created_at, :comment, 
		:pure_product_price, :tax, :delivery_charge, :total_price



	has_many :line_items
end
