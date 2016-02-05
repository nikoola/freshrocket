class LineItem < ActiveRecord::Base
	#doesn't exist out of order context

	belongs_to :order
	belongs_to :product

	validates :order, :product, :amount, presence: true #no :fixed_price, as it's controlled by order

	validates_numericality_of :amount, greater_than_or_equal_to: 0, only_integer: true

	
	def set_fixed_price
		self.fixed_price = self.product.price * self.amount
	end

	validates_associated :product



end
