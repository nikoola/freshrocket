class CalculateOrderPrice
	def initialize order
		@order = order
	end

	attr_reader :tax, :pure_product_price, :delivery_charge, :total



	def delivery_charge
		@delivery_charge ||= 
			if pure_product_price < Setting.s.free_delivery_order_sum
				Setting.s.default_delivery_cost
			else
				0
			end
	end

	def tax
		@tax ||= pure_product_price * ( Setting.s.tax_in_percentage / 100 )
	end

	def total
		@total ||= pure_product_price + tax + delivery_charge 
	end


	#nested attributes are validated first
	# self.fixed_price = self.line_items.sum(:fixed_price) #0! ahh, they are not in database yet, and sum's a db method
	def pure_product_price
		@pure_product_price ||= @order.line_items.map do |li| 
			li.fixed_price = li.product.price * li.amount #they are saved, yes, all fine.
		end.reduce { |sum, n| sum + n }
	end




end







