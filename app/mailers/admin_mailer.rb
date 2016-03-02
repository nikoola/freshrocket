class AdminMailer < ApplicationMailer


	def contact_form(contact_form)
		@contact_form = JSON.parse contact_form

		mail(to: 'admin@admin_email.com', from: @contact_form['email'], subject: "Contact Us")
	end


end


