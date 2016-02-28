require 'rails_helper'




# https://github.com/rails/rails/issues/17216
describe 'Angular: parameter wrapping', type: :request do

	let(:user)         { FactoryGirl.create :user, abilities: [:cities] }
	let(:auth_headers) { user.create_new_auth_token }

	it 'accepts simple args without model mentioned' do

		# we need to set additional headers for parameters wrapping to work
		post '/admin/cities', { name: 'wow', areas_attributes: [
			{ name: 'area_1' },
			{ name: 'area_2' }
		] }.to_json, auth_headers.merge('ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json')

		city = City.find(json_body[:id])

		expect(city.areas.count).to eq(2)
	end



end
