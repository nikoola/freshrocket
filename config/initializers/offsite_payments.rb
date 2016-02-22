

require 'offsite_payments'
OffsitePayments.mode = :test # for testing server
# ActiveMerchant::Billing::Base.integration_mode = :production




CITRUS = {
	vanity_url: 'kouqfeaav0',
	secret_key: '1690a1e29ecec2a5f852b678dd5362616c79916a',
	access_key: 'T82TNCTLNBZ282BLHAGD',
	return_url: 'http://localhost:3000/client/payments/citrus'
}


