class Order < ActiveRecord::Base
	include AASM
	include Filterable

	belongs_to :user
	belongs_to :delivery_boy

	has_many :line_items, inverse_of: :order, dependent: :destroy #so that on nested attrs order id in line_item is set
	has_many :products,   through: :line_items #for testing


	accepts_nested_attributes_for :line_items, allow_destroy: true #Note that the :autosave option is automatically enabled on every association that #accepts_nested_attributes_for is used for

	validates_presence_of :user
	validate              :has_line_items?
	validate              :coupon_can_be_found?, 
		if: :coupon_code_changed?, 
		unless: -> { coupon_code.blank? }

	before_save           :set_order_pricing, if: :unconfirmed?

	include Filterable
	scope :status,  -> (status)  { where status: status }
	scope :city_id, -> (city_id) { where city_id: city_id }
	scope :user_id, -> (city_id) { where user_id: city_id }

	# Saving includes running all validations on the Job class.
	aasm column: :status, no_direct_assignment: true, whiny_transitions: false do
		state :unconfirmed, :initial => true
		state :confirmed
		state :approved
		state :dispatched
		state :delivered

		state :canceled

		event :confirm do #payment makes order automatically confirmed
			transitions :from => :unconfirmed, :to => :confirmed, 
				after: :decrease_stock, 
				guard: :payment_ready_for_confirm?
		end
		event :approve do
			after {
				send_order_summary
				SendConfirmationSmsJob.perform_later user.name, user.phone
			}
			transitions :from => :confirmed, :to => :approved
		end
		event :dispatch do
			after {
				SendDispatchSmsJob.perform_later user.name, user.phone
			}
			transitions :from => :approved, :to => :dispatched, 
				guard: :delivery_boy_assigned?
		end
		event :deliver do
			transitions :from => :dispatched, :to => :delivered
		end
		event :cancel do
			after {
				increase_stock
				SendCancellationSmsJob.perform_later user.name, user.phone
			}
			transitions :from => [:confirmed, :approved], :to => :canceled
		end
	end


	DELIVERY_TIMES = ['morning', 'noon', 'evening']
	validates_inclusion_of :wanted_time, in: DELIVERY_TIMES, 
		allow_blank: true, 
		message: "%{value} is not permitted. can be #{DELIVERY_TIMES}"

	validate  :wanted_date_is_in_proper_range?


	PAYMENT_TYPES = ['cash', 'citrus']
	validates_inclusion_of :payment_type, in: PAYMENT_TYPES, 
		allow_blank: true, 
		message: "%{value} is not permitted. can be #{PAYMENT_TYPES}"




	# Since version 3.0.13 AASM supports ActiveRecord transactions. So whenever a transition callback or the state update fails, all changes to any database record are rolled back. Mongodb does not support transactions.
	def decrease_stock

		# http://stackoverflow.com/a/19549322/3192470 why requires_new ?
		# Order.transaction(requires_new: true) do # transaction only rolls back if an exception is raised
		line_items.each do |line_item|

			product = line_item.product

			amount_wanted  = line_item.amount
			amount_present = product.inventory_count

			unless product.update(inventory_count: amount_present - amount_wanted)
				errors.add(
					"stock shortage", 
					{
						"product.inventory_count": amount_present, 
						"line_item.amount": amount_wanted, 
						"product.id": product.id, 
						"line_item.id": line_item.id
					}
				)
			end

		end

		raise ActiveRecord::Rollback if errors.present? # rollback all if at least one product failed
		# end
	end


	def increase_stock
		line_items.each do |line_item|
			product = line_item.product

			amount_to_return = line_item.amount
			amount_present   = product.inventory_count

			product.update(inventory_count: amount_present + amount_to_return)
		end
	end


	def update_status action # :confirm, :approve, :dispatch, :deliver, :cancel
		if self.respond_to?("may_#{action}?")
			if self.send("may_#{action}?") #calls guards too TODO! we'll be calling guards twice then.
				self.send(action + '!')
			else
				errors.add(:status, "status cannot transition from #{status} to #{action}")
			end
		else
			errors.add(:status, "status of #{action} is not valid.  Legal values are #{aasm.states.map(&:name).join(", ")}")
		end
	end

	def coupon
		Coupon.find_by(code: coupon_code)
	end



	private
		def has_line_items?
			errors.add(:order, 'must add at least one line item') if self.line_items.blank?
		end

		def wanted_date_is_in_proper_range?
			if wanted_date.present?
				if wanted_date > (Date.today + 3.days)
					errors.add(:wanted_date, "can't be in more than tree days")
				elsif wanted_date < Date.today
					errors.add(:wanted_date, "can't be in the past")
				end
			end
		end

		def set_order_pricing
			pricing = CalculateOrderPrice.new self

			self.pure_product_price = pricing.pure_product_price
			self.tax                = pricing.tax
			self.delivery_charge    = pricing.delivery_charge
			self.coupon_discount    = pricing.coupon_discount

			self.total_price        = pricing.total
		end

		def send_order_summary
			UserMailer.order_summary(self).deliver_later
		end


		def delivery_boy_assigned?
			if delivery_boy
				true
			else
				errors.add(:order, 'needs to be assigned to some delivery boy before dispatching')
				false
			end

		end



		def payment_ready_for_confirm?
			case payment_type
			when 'cash'
				true
			when nil
				errors.add(:order, 'needs to have payment type before being confirmed')
				false
			else
				if is_paid
					true
				else
					errors.add(:order, 'either select payment by cash, or pay prior to confirming order')
					false
				end
			end
		end




		def coupon_can_be_found?
			if !coupon #if coupon can't be found
				errors.add(:coupon_code, 'there is no such coupon')
			end
		end

end









