___why integration and not gateway?
	With the gateway there is clearly much more flexibility, but the onus rests on the user application to collect the CC details and to pass the PCI compliance requirements that come along with handling card details (At the minimum these include requiring end to end encryption of all card details and submitting your application for regular PCI compliance scans. However, these rules are tightening rapidly and the burden of compliance is becoming quite substantial ('https://github.com/activemerchant/active_merchant/wiki/GatewaysVsIntegrations')
	aand we dont have Citrus gateway anywhere anyway. 

	activemerchant split up the project into self and offsite_payments. all integrations belong in latter now. there is no Citrus integration in current gem. but it there is one in versions of activemerchant prior to 1.46.0.
	# (* CHANGE: remove `OffsitePaymentShim`. You will have to add offsite_payments as a dependency, and update any mentions of `ActiveSupport::Billing::Integration` to`OffsitePayments::Integrations`.)

___how to use offsite_payments?
	'https://github.com/activemerchant/offsite_payments/issues/80'







