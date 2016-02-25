class CitySerializer < ActiveModel::Serializer
	attributes :id, 
		:name, :active
	has_many :areas
end
