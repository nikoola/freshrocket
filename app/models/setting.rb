class Setting < ActiveRecord::Base

	DEFAULT_SETTINGS = {
		tax_in_percentage:       5,
		free_delivery_order_sum: 500,
		default_delivery_cost:   200
	}

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

		def instance
			Setting.first || Setting.create(DEFAULT_SETTINGS)
		end
		alias_method :i, :instance
		alias_method :s, :instance #like Setting.s


	end

	self.instance  #in case if database is empty create
	# Setting instance, just so we don't have to provide creation route.



end



