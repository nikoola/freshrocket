
require 'rails_helper'

describe '', type: :request do

	it '' do
		CITRUS = {
			vanity_url: 'kouqfeaav0',
			secret_key: '1690a1e29ecec2a5f852b678dd5362616c79916a',
			access_key: 'T82TNCTLNBZ282BLHAGD',
			return_url: 'http://localhost:3000/client/paid'
		}

		get '/client/new'
		# require 'offsite_payments'
		# OffsitePayments.mode = :test


		# p @helper.form_fields

		# require 'pry'
		# binding.pry

		# require 'offsite_payments/action_view_helper'
		# include OffsitePayments::ActionViewHelper

		aa = payment_service_for('11111', CITRUS[:access_key],
			amount: 10, currency: 'USD',
			credential2: CITRUS[:secret_key],
			credential3: CITRUS[:vanity_url],
			return_url:  CITRUS[:return_url],
			service: :citrus
		) {}


	end



end