class ClientMailer < ApplicationMailer
	default from: 'notifications@example.com' #TODO

	def order_summary(order)
		@order = order

		attachments["order_#{@order.id}.pdf"] = WickedPdf.new.pdf_from_string(
			render_to_string
		)

		mail(to: @order.user.email, subject: 'Your order has been approved')
	end


end


