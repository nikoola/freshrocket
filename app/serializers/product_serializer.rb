class ProductSerializer < ActiveModel::Serializer
  attributes :id,
  	:city_id,
  	:title, :price,
  	:created_at, :updated_at,
  	:inventory_count, :image_url

  def method_name
  	object.image.url
  end
end
