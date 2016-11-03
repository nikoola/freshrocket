class ProductSerializer < ActiveModel::Serializer
	attributes :id,
		:city_id,
		:title, :price, :description,
		:created_at, :updated_at,
		:inventory_count, :image_url,
	  :categories

	has_many :categories
	has_many :options

	def image_url
		object.image ? object.image.url : nil
	end
end
