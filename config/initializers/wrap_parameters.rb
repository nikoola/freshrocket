
# I monkey patched this so that nested params can be given by angular without the root element too, see
# https://github.com/rails/rails/issues/17216
module ActionController
	module ParamsWrapper

		Options.class_eval do



			def include
				return super if @include_set

				m = model
				synchronize do
					return super if @include_set

					@include_set = true

					unless super || exclude
						if m.respond_to?(:attribute_names) && m.attribute_names.any?
							# wrap_parameters add: [:password, :password_confirmation] #for devise to work, may want to limit to more specific cotrollers later. #no :add method now, kinda tricky to implement. use below method for now:
							custom = if m == User
								[:password, :password_confirmation]
							elsif m == Product
								[:category_ids]
							elsif m == City
								[:stringified_polygon]
							else
								[]
							end

							self.include = m.attribute_names + nested_attributes_names_array_of(m) + custom
						end
					end
				end
			end

			private 
				# added method. by default code was equivalent to this equaling to []
				def nested_attributes_names_array_of model
					model.nested_attributes_options.keys.map { |nested_attribute_name| 
						nested_attribute_name.to_s + '_attributes' 
					}
				end
		end

	end
end






# This file contains settings for ActionController::ParamsWrapper which
# is enabled by default.

# Enable parameter wrapping for JSON. You can disable this by setting :format to an empty array.
ActiveSupport.on_load(:action_controller) do
	wrap_parameters format: [:json] if respond_to?(:wrap_parameters)
end

# To enable root element in JSON for ActiveRecord objects.
# ActiveSupport.on_load(:active_record) do
#  self.include_root_in_json = true
# end
