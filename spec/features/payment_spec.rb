
require 'rails_helper'
require 'capybara/rspec'


Capybara.default_driver = :selenium


describe 'Payment', type: [:feature, :request], js: true do #for some reason js: true gives us otherwise nonseen json response with factored things

	let(:order){ FactoryGirl.create :order }

	it 'citrus' do
		# get '/client/payments/new', { order_id: order.id, amount: order.total_price }
		# data = json_body[:citrus]


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
		# binding.pry
		#works, now need to register as a client
	end



end


