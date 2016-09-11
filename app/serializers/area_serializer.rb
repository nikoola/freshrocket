class AreaSerializer < ActiveModel::Serializer
  attributes :id, :name, :radius, :active, :lat, :lng, :city_id
end
