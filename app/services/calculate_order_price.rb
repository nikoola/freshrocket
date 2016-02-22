class CalculateOrderPrice

	attr_reader :tax, :pure_product_price, :delivery_charge, :total, :coupon_discount

	def initialize order
		@order = order

		@pure_product_price = get_pure_product_price

		# in any order
		@delivery_charge = get_delivery_charge @pure_product_price
		@tax             = get_tax             @pure_product_price
		@coupon_discount = get_coupon_discount @pure_product_price

		@total           = get_total
	end


	private 
		def get_total
			@pure_product_price + @tax + @delivery_charge - @coupon_discount
		end

		#nested attributes are validated first
		# self.fixed_price = self.line_items.sum(:fixed_price) #0! ahh, they are not in database yet, and sum's a db method
		def get_pure_product_price
			@order.line_items.map do |li|
				li.fixed_price = li.product.price * li.amount #they are saved, yes, all fine.
			end.reduce { |sum, n| sum + n }
		end

		def get_delivery_charge pure_product_price
			if pure_product_price < Setting.s.free_delivery_order_sum
				Setting.s.default_delivery_cost
			else
				0
			end
		end

		def get_tax pure_product_price
			pure_product_price * ( Setting.s.tax_in_percentage / 100.0 )
		end

		def get_coupon_discount pure_product_price
			if @order.coupon
				pure_product_price * ( @order.coupon.discount / 100.0 )
			else
				0
			end
		end



end







