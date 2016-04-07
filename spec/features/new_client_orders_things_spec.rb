require 'rails_helper'
include ActiveJob::TestHelper

describe '', type: :request do


	it 'new client orders things' do
		ActiveJob::Base.queue_adapter = :test
		password = 'hihihi00'

		puts 'admin-to-be signs up'
		post '/auth', FactoryGirl.attributes_for(:user, password: password, password_confirmation: password)
		expect_status 200

		id = json_body[:data][:id]
		admin = User.find(id)




		puts 'we manually make first user an admin'
		admin.add_ability 'users'
		admin.save!




		puts 'admin signs in'
		post '/auth/sign_in', { email: admin.email, password: password }
		expect_status 200

		admin_headers = headers.slice("access-token", "token-type", "uid", "client")




		puts 'admin tries to creates category and fails'
		post '/admin/categories', { category: { name: 'breakfasts' } }, admin_headers
		expect_status 401




		puts 'admin gives herself necessary rights'
		put "/admin/users/#{admin.id}/update_abilities", { abilities: { 'users' => 1, 'products' => 1, 'orders' => 1, 'categories' => 1 } }, admin_headers
		expect_status 200




		puts 'admin can create category now'
		post '/admin/categories', { category: { name: 'breakfasts' } }, admin_headers
		expect_status 201

		category = Category.find(json_body[:id])



		# puts 'admin creates city' to do?
		# post '/admin/cities', { city: { name: 'New York' } }, admin_headers
		# expect_status 201
		city = City.create FactoryGirl.attributes_for(:city)




		puts 'admin creates product'
		post '/admin/products', { product: { title: 'fish', price: '3.0', inventory_count: 2, city_id: city.id, category_ids: [category.id] } }, admin_headers
		expect_status 201
		product = Product.find(json_body[:id])
		expect(product.categories.pluck(:id)).to eq([category.id])





		password = 'wowoworewc7'

		puts 'client-to-be signs up' 
		post '/auth', FactoryGirl.attributes_for(:user, password: password, password_confirmation: password)
		expect_status 200

		id = json_body[:data][:id]
		client = User.find(id)



		puts 'client signs in'
		post '/auth/sign_in', email: client.email, password: password

		client_headers = headers.slice("access-token", "token-type", "uid", "client")



		puts 'client confirms phone'
		expect {
			post '/client/send_verification_sms', client_headers
		}.to have_enqueued_job.on_queue('sms')






		# puts 'try to make an order without confirming the phone'
		# post '/'


	end





	# it 'hi' do

	# 	OmniAuth.config.test_mode = true
	# 	OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
	# 		provider: 'facebook',
	# 		uid: '123545',
	# 		info: {
	# 			first_name: "Gaius",
	# 			last_name:  "Baltar",
	# 			email:      "test@example.com"
	# 		},
	# 		credentials: {
	# 			token: "123456",
	# 			expires_at: Time.now + 1.week
	# 		},
	# 		extra: {
	# 			raw_info: {
	# 				gender: 'male'
	# 			}
	# 		}
	# 	})

	# 	get "/auth/facebook/callback"
	# 	request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
	# 	request.env['devise.mapping'] = Devise.mappings[:user] 
	# 	p json_body
	# end
end
