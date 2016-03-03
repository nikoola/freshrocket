class OrderSerializer < ActiveModel::Serializer
	attributes :id, :user_id, :status, :created_at, :comment,
		:pure_product_price, :tax, :delivery_charge, :total_price,
		:delivery_boy_id,
		:wanted_time, :wanted_date,
		:payment_type, :is_paid,
		:feedback, 
		:coupon_code,
		:source_type



	has_many   :line_items
	has_one :address


end
