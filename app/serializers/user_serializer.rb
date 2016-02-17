class UserSerializer < ActiveModel::Serializer
  attributes :id,
  	:email, :phone, :is_verified,
		:provider,
		:uid,
		:created_at



end
