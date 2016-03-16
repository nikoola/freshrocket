class CategorySerializer < ActiveModel::Serializer
	attributes :id,
		:name, :image_url


	def image_url
		# binding.pry
		# if object.changed?
		# 	object.reload.image.url
		# else
			object.image.url
		# end
	end
end

