
require 'rails_helper'
require 'capybara/rspec'


Capybara.default_driver = :selenium

describe 'Payment', type: [:feature, :request], js: true do #for some reason js: true gives us otherwise nonseen json response with factored things


	let(:user) { FactoryGirl.create :user }
	let(:auth_headers) { user.create_new_auth_token }

	let(:order){ FactoryGirl.create :order, user_id: user.id, id: rand(1000000..99999999) }

	it 'citrus' do
		get '/client/payments/new', { order_id: order.id, amount: order.total_price }, auth_headers
		data = json_body[:citrus]

		expect_status 200

		# create_fields data
		# works, now need to register as a client
	end

	describe 'paytm' do
		it 'paytm' do
			get '/client/payments/new', { 
				order_id:    order.id,
				total_price: order.total_price 
			}, auth_headers
			data = json_body[:paytm]

			expect_status 200

			# create_fields data
			# page.click_button 'Pay'

			# page.click_link 'Login'
			# within_frame 'login-iframe' do
			# 	page.find('input[name="username"]').set '7777777777'
			# 	page.find('input[name="password"]').set 'Paytm12345'
			# 	page.click_button 'Secure Sign In'
			# end

			# binding.pry
		end


		it 'notification' do
			order = FactoryGirl.create :order, id: 84825879
			params = {
				CURRENCY: 'INR',
				TXNAMOUNT: '228.35',
				BANKTXNID: '176005',
				TXNDATE: '2016-04-21 19:49:19.0',
				GATEWAYNAME: 'WALLET',
				STATUS: 'TXN_SUCCESS',
				MID: 'FreshD33860006728322',
				ORDERID: '84825879',
				PAYMENTMODE: 'PPI',
				RESPCODE: '01',
				RESPMSG: 'Txn Successful.',
				BANKNAME: '',
				TXNID: '734611',
				CHECKSUMHASH: '73tx6aQlue3377AZ05ZltfYMjUMy8a+XiYbYVPG5C1jQhW2Zm/1yHRDHDjS6VkzKs+5kdH2JBEWqg/+quKRkumkdwNJTbrlvdQWRZFxdezM='
			}

			post '/client/payments/paytm', params
			expect_status 200
			
			expect(order.reload.is_paid).to be true


		end

	end

	def create_fields data
		visit '/products' #is a random page, 

		inputs = []
		data[:fields].each do |k, v|
			inputs << "<input type='text' name='#{k}' value='#{v}' />"
		end

		submit_button = " <button type='submit'>Pay</button> "
		form_fields = 
			"<form action='#{data[:action]}' method='#{data[:method]}'>" +
				inputs.join(" ") +
				submit_button +
			"</form>";


		page.evaluate_script("document.body.innerHTML += \"#{form_fields}\";")
	end


end


