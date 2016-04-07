
require 'rails_helper'
require 'capybara/rspec'


Capybara.default_driver = :selenium

describe 'Payment', type: [:feature, :request], js: true do #for some reason js: true gives us otherwise nonseen json response with factored things


	let(:user) { FactoryGirl.create :user }
	let(:auth_headers) { user.create_new_auth_token }

	let(:order){ FactoryGirl.create :order, user_id: user.id }

	it 'citrus' do
		get '/client/payments/new', { order_id: order.id, amount: order.total_price }, auth_headers
		data = json_body[:citrus]

		expect_status 200

		# visit '/products'

		# inputs = []
		# data[:fields].each do |k, v|
		# 	inputs << "<input type='text' name='#{k}' value='#{v}' />"
		# end

		# submit_button = " <input type='submit'> "
		# form_fields = "<form action='#{data[:action]}' method='#{data[:method]}'>" +
		# 	inputs.join(" ") +
		# 	submit_button +
		# 	"</form>";


		# page.evaluate_script("document.body.innerHTML += \"#{form_fields}\";")
		# works, now need to register as a client
	end

	# it 'paytm' do
	# 	get '/client/payments/new', { order_id: order.id, amount: order.total_price }, auth_headers
	# 	data = json_body[:paytm]

	# 	expect_status 200

	# 	visit '/products' #is a random page, 

	# 	inputs = []
	# 	data[:fields].each do |k, v|
	# 		inputs << "<input type='text' name='#{k}' value='#{v}' />"
	# 	end

	# 	submit_button = " <input type='submit'> "
	# 	form_fields = 
	# 		"<form action='#{data[:action]}' method='#{data[:method]}'>" +
	# 			inputs.join(" ") +
	# 			submit_button +
	# 		"</form>";


	# 	page.evaluate_script("document.body.innerHTML += \"#{form_fields}\";")
	# 	# works, now need to register as a client
	# 	binding.pry
	# end


end


