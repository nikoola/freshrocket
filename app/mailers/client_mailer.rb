class ClientMailer < ApplicationMailer
	default from: 'notifications@example.com'

	def order_summary(order)
		@order = order

		mail(to: @order.user.email, subject: 'Your order has been approved')
	end


end


o = Order.first
ClientMailer.order_summary(o).deliver_later

