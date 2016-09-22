class CitySerializer < ActiveModel::Serializer
	attributes :id, 
		:name, :active

	has_many :products
end
