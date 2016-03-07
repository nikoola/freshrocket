class UserSerializer < ActiveModel::Serializer
  attributes :id,
  	:first_name, :last_name,
  	:email, :phone, :is_verified,
		:provider,
		:uid,
		:created_at,
		:abilities

	has_many :addresses
	has_many :orders


	def abilities
		manipulation = ManipulateUserAbilities.new object
		manipulation.list
	end


end
