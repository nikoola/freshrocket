module Filterable
	extend ActiveSupport::Concern

	module ClassMethods

		# User.filter active: true
		def filter filtering_params
			results = self.where(nil)
			filtering_params.each do |key, value|
				results = results.public_send(key, value) # if value.present?
				# User.active(true)
			end
			results
		end

		def param_to_bool param_boolean
			case param_boolean.to_s
			when '1' 
				true
			when '0'
				false
			end
		end

	end
end

