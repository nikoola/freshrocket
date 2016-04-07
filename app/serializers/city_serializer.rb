class CitySerializer < ActiveModel::Serializer
	attributes :id, 
		:name, :active, :polygon


end
