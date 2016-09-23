class CitySerializer < ActiveModel::Serializer
	# default_includes ''
	attributes :id, 
		:name, :active

	has_many :products do 
		include_data :if_included
		
	end
end
