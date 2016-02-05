class Order < ActiveRecord::Base
	include AASM
	include Filterable

	belongs_to :user
	has_many :line_items, inverse_of: :order, dependent: :destroy #so that on nested attrs order id in line_item is set

	has_many :products, through: :line_items #for validations


	accepts_nested_attributes_for :line_items, allow_destroy: true #Note that the :autosave option is automatically enabled on every association that #accepts_nested_attributes_for is used for

	validates_presence_of :user
	validate :has_line_items?


	before_save :set_fixed_price, :if => :unconfirmed? 

	include Filterable
	scope :status,  -> (status) { where status: status }


	aasm column: :status, no_direct_assignment: true, whiny_transitions: false do
		state :unconfirmed, :initial => true
		state :confirmed
		state :approved
		state :dispatched
		state :delivered

		state :canceled

		event :confirm do
			# guard do
			# 	change_stock :minus
			# end
			transitions :from => :unconfirmed, :to => :confirmed, guard: :decrease_stock
		end
		event :approve do
			transitions :from => :confirmed, :to => :approved
		end
		event :dispatch do
			transitions :from => :approved, :to => :dispatched
		end
		event :deliver do
			transitions :from => :dispatched, :to => :delivered
		end
		event :cancel do
			# guard do
			# 	change_stock :plus
			# end
			transitions :from => [:confirmed, :approved], :to => :canceled
		end
	end



	validates_associated :line_items



	def decrease_stock
		line_items.each do |line_item|
			product = line_item.product

			of_product_in_order = line_item.amount

			if product.inventory_count < of_product_in_order
				errors.add("products", {"product.inventory_count": product.inventory_count, "line_item.amount": line_item.amount, "product.id": product.id})
			else
				product.inventory_count -= of_product_in_order
			end
		end

		if errors.empty?
			save #can return false too
		else
			false
		end
	end




	def update_status action # :confirm, :approve, :dispatch, :deliver, :cancel
		if self.respond_to?("may_#{action}?")
			if self.send("may_#{action}?")
				self.send(action + '!')
				save
			else
				errors.add(:status, "status cannot transition from #{status} to #{action}"); false
			end
		else
			errors.add(:status, "status of #{action} is not valid.  Legal values are #{aasm.states.map(&:name).join(", ")}"); false
		end
	end















	private
		def has_line_items?
			errors.add(:order, 'must add at least one line item') if self.line_items.blank?
		end

		def set_fixed_price
			#nested attributes are validated first
			self.fixed_price = self.line_items.map(&:set_fixed_price).reduce {|sum, n| sum + n}
			# self.fixed_price = self.line_items.sum(:fixed_price) #0! ahh, they are not in database yet, and sum's a db method
		end

end









