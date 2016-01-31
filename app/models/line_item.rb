class LineItem < ActiveRecord::Base
	#doesn't exist out of order context

	belongs_to :order
	belongs_to :product

	validates :order, :product, :amount, presence: true #no :fixed_price, as it's controlled by order


	
	def set_fixed_price
		self.fixed_price = self.product.price * self.amount
	end





end
