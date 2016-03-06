class OrderSerializer < ActiveModel::Serializer
	attributes :id, :user_id, :status, :created_at,
		:pure_product_price, :tax, :delivery_charge, :total_price,
		:delivery_boy_id,
		:wanted_time, :wanted_date,
		:payment_type, :is_paid,
		:feedback, :comment, :admin_comment,
		:coupon_code,
		:source_type



	has_many   :line_items
	has_one :address

	def filter(keys)
		if scope.has_ability? 'orders'
			keys
		else
			keys - [:admin_comment]
		end
	end



end
