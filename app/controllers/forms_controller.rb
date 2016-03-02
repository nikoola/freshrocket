class FormsController < ApplicationController


	def contact
		contact_form = ContactForm.new params[:form]
		if contact_form.valid?
			AdminMailer.contact_form(contact_form.to_json).deliver_later
			head 200
		else
			render json: contact_form.errors, status: 422
		end
	end






end
