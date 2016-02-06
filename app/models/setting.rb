class Setting < ActiveRecord::Base

	validate :only_one_record?, on: :create


  validates_numericality_of :free_delivery_order_sum, :default_delivery_cost

  validates :tax_in_percentage, numericality: { 
  	greater_than_or_equal_to: 0, 
  	less_than_or_equal_to: 100 
  }

	private
		def only_one_record?
			unless self.class.count == 0
				errors.add(:base, "there can only be one row in this table, and it already exists")
			end
		end







	class << self
		def set_default_record
			if count == 0 
				create! tax_in_percentage:  5.00,
					free_delivery_order_sum: 500,
					default_delivery_cost:   200
			end
		end

		def instance
			default_settings = {
				tax_in_percentage:       0,
				free_delivery_order_sum: 500,
				default_delivery_cost:   200
			}
			Setting.first || Setting.create(default_settings)
		end
		alias_method :i, :instance

		# def define_singleton_methods
		# 	column_names.each do |column_name|
		# 		define_singleton_method column_name do
		# 			first.send(column_name)
		# 		end
		# 	end
		# end
	end

	set_default_record
	# define_singleton_methods

end



