class CouponSerializer < ActiveModel::Serializer
	attributes :id,
		:name, :code, :discount
end
