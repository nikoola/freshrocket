module Filterable
	extend ActiveSupport::Concern

	module ClassMethods

		# User.filter active: true
		def filter filtering_params
			# binding.pry
			results = self.where(nil)
			filtering_params.each do |key, value|
				if key.to_s == "name"
					results = results.public_send(:starts_with, value) # if value.present?					
				else
					results = results.public_send(key, value) # if value.present?
				end
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

