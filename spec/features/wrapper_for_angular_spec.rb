require 'rails_helper'




# accepts simple args without model mentioned
# https://github.com/rails/rails/issues/17216
describe 'Angular: parameter wrapping', type: :request do

	let(:user)         { FactoryGirl.create :user, abilities: [:cities, :users] }
	let(:auth_headers) { user.create_new_auth_token }

	it '/admin/cities' do

		# we need to set additional headers for parameters wrapping to work
		post '/admin/cities', { name: 'wow', areas_attributes: [
			{ name: 'area_1' },
			{ name: 'area_2' }
		] }.to_json, auth_headers.merge('ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json')
		# to_json is necessary

		city = City.find(json_body[:id])

		expect(city.areas.count).to eq(2)
	end






	it '/admin/users' do
		client = FactoryGirl.create :user
		password = 'hhhhhhhhhh'

		#post works too
		put "/admin/users/#{client.id}", {
			password:              password,
			password_confirmation: password
		}.to_json, auth_headers.merge('ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json')

		post '/auth/sign_in', {
			email:    client.email,
			password: password
		}

		expect_status 200 #401 if password was wrong
		expect(headers).to include("access-token", "token-type", "client", "expiry", "uid")
	end



end
