class OrderSerializer < ActiveModel::Serializer
	attributes :id, :user_id, :status, 
		:created_at,
		:pure_product_price, :tax, :delivery_charge, :total_price,
		:delivery_boy_id,
		:wanted_time, :wanted_date,
		:payment_type, :is_paid,
		:feedback, :comment,
		:coupon_code,
		:source_type
	attribute :admin_comment, if: :current_user_can_manage_admins



	has_many :line_items
	has_one  :address


	def current_user_can_manage_admins
		scope.has_ability? 'orders'
	end



end
