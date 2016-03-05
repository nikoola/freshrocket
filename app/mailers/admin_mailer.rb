class AdminMailer < ApplicationMailer


	def contact_form(contact_form)
		@contact_form = JSON.parse contact_form

		mail(to: 'Sathish@greenridge.in', from: @contact_form['email'], subject: "Contact Us")
	end


end


