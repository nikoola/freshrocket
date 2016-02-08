class UserSerializer < ActiveModel::Serializer
  attributes :id,
  	:email, :phone,
		:provider,
		:uid,
		:created_at



end
