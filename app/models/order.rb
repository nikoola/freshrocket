class Order < ActiveRecord::Base
	include AASM
	include Filterable
	

	belongs_to :user
	belongs_to :delivery_boy
	belongs_to :address, :inverse_of => :orders
	# attr_accessor :address_id

	has_many :line_items, inverse_of: :order, dependent: :destroy #so that on nested attrs order id in line_item is set
	has_many :products,   through: :line_items


	accepts_nested_attributes_for :line_items, allow_destroy: true #Note that the :autosave option is automatically enabled on every association that #accepts_nested_attributes_for is used for

	accepts_nested_attributes_for :address,  allow_destroy: true#reject_if: reject_address

  	
	validates_presence_of :user,:address
	# validates_presence_of :address, :if => proc{|attributes| attributes['address_attributes'].nil?}
	validate              :has_line_items?
	validate              :coupon_can_be_found?, 
		if: :coupon_code_changed?, 
		unless: -> { coupon_code.blank? }

	before_save           :set_order_pricing, if: :unconfirmed?
	# def method_name
	# 	self.random_unique_token = rand(10000000..9999999)
		
	# end

	scope :status,  -> (status) { where status: status }
	scope :user_id, -> (id)     { where user_id: id }
	scope :city_id, -> (id)     { joins(:address).where( 'addresses.city_id': id ) }

	# Saving includes running all validations on the Job class.
	aasm column: :status, no_direct_assignment: true, whiny_transitions: false do
		state :unconfirmed, :initial => true
		state :confirmed
		state :approved
		state :dispatched
		state :delivered

		state :canceled

		event :confirm do #payment makes order automatically confirmed
			after {
				touch :confirmed_at
				decrease_stock
			}
			transitions :from => :unconfirmed, :to => :confirmed,
				guard: :payment_ready_for_confirm?
		end
		event :approve do
			after {
				touch :approved_at
				send_order_summary
				SendConfirmationSmsJob.perform_later user.name, user.phone
			}
			transitions :from => :confirmed, :to => :approved do
				guard {
					if payment_type != 'cash' and !is_paid
						errors.add :order, 'should be either paid by cash on arrival or paid by some online payment prior to approval'
						false
					else
						true
					end
				}
			end
		end
		event :dispatch do
			after {
				touch :dispacthed_at
				SendDispatchSmsJob.perform_later user.name, user.phone
				delivery_boy.update status: :busy
			}
			transitions :from => :approved, :to => :dispatched, 
				guard: :delivery_boy_assigned?
		end
		event :deliver do #if cash mark as paid first
			after {
				touch :delivered_at
			}
			transitions :from => :dispatched, :to => :delivered do
				guard {
					if is_paid
						true
					else
						errors.add :order, 'needs to be paid prior to confirming delivery'
						false
					end
				}
			end
		end
		event :cancel do
			after {
				touch :canceled_at
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

	validate :wanted_date_is_in_proper_range?
	validate :wanted_date_is_set_if_wanted_time_is_set


	PAYMENT_TYPES = ['cash', 'citrus', 'paytm']
	validates_inclusion_of :payment_type, in: PAYMENT_TYPES, 
		allow_blank: true, 
		message: "%{value} is not permitted. can be #{PAYMENT_TYPES}"

	SOURCE_TYPES = ['web', 'phone', 'mobile']
	validates_inclusion_of :source_type, in: SOURCE_TYPES, 
		allow_blank: true, 
		message: "%{value} is not permitted. can be #{SOURCE_TYPES}"


	validate :everything_is_from_the_same_city?


	delegate :city_id, to: :address



	def reject_address(attributes)
   		attributes.any? {|key,val| val.blank?}
  	end

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
			if self.send("may_#{action}?")
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

		def wanted_date_is_set_if_wanted_time_is_set
			if wanted_time and !wanted_date
				errors.add(:wanted_date, "must be set if wanted time is set")
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
			ClientMailer.order_summary(self).deliver_later
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



		def everything_is_from_the_same_city?
			# binding.pry
			products.each do |p|
				unless p.city_id == address.city_id
					errors.add(:product, "#{p.title} is from #{p.city.name}, and your address is from #{address.city.name}")
				end
			end

		end

end

