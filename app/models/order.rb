class Order < ActiveRecord::Base
	include Filterable
	belongs_to :user

	has_many :line_items, inverse_of: :order, dependent: :destroy #so that on nested attrs order id in line_item is set
	# has_many   :products, through: :line_items

	accepts_nested_attributes_for :line_items, allow_destroy: true

	validates_presence_of :user

	validates_associated :line_items
	validate :has_line_items
	def has_line_items
		errors.add(:order, 'must add at least one line item') if self.line_items.blank?
	end


	before_save :set_fixed_price#, if: order.status unconfirmed TODO
	def set_fixed_price
		#nested attributes are validated first
		self.fixed_price = self.line_items.map(&:set_fixed_price).reduce {|sum, n| sum + n}
		# self.fixed_price = self.line_items.sum(:fixed_price) #0! ahh, they are not in database yet, and sum's a db method
	end


	# :created, :confirmed, :approved, :dispatched, :delivered
	# :canceled




end









