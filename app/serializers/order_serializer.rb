class OrderSerializer < ActiveModel::Serializer
	attributes :id, :user_id, :status, :created_at, :comment, 
		:pure_product_price, :tax, :delivery_charge, :total_price,
		:delivery_boy_id,
		:wanted_time, :wanted_date,
		:payment_type, :is_paid



	has_many :line_items
end
