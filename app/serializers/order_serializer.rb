class OrderSerializer < ActiveModel::Serializer
	attributes :id, :user_id, :status, 
		:created_at, :confirmed_at, :approved_at, :dispacthed_at, :delivered_at, :canceled_at,
		:pure_product_price, :tax, :delivery_charge, :total_price, :coupon_code,
		:delivery_boy_id, :delivery_boy_phone,
		:wanted_time, :wanted_date,
		:payment_type, :is_paid,
		:feedback, :comment,
		:source_type
		
	attribute :admin_comment, if: :current_user_can_manage_admins



	has_many   :line_items
	has_one    :address
	belongs_to :delivery_boy


	def current_user_can_manage_admins
		scope.has_ability? 'orders'
	end

	def delivery_boy_phone
		db = object.delivery_boy
		db ? db.user.phone : nil
	end



end
