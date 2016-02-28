class CategorySerializer < ActiveModel::Serializer
	attributes :id,
		:name, :image_url

	has_many :products

	def image_url
		object.image.url
	end
end
