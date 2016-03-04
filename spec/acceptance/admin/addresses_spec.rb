require 'rails_helper'

resource 'admin: addresses', type: :request do

	let(:user) { FactoryGirl.create :user, abilities: ['users'] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:address) { FactoryGirl.create :address, user_id: user.id }
	let(:city)    { FactoryGirl.create :city }

	get '/admin/addresses' do
		parameter :active, '0/1. is inactive if user tried to delete order, but it was already mentioned in any orders'

		example 'get all own addresses' do
			FactoryGirl.create_list :address, 3, active: false
			FactoryGirl.create_list :address, 2

			do_request active: 0

			returned_ids = jsons.pluck(:id)
			expected_ids = Address.where(active: false).pluck(:id)

			expect(status).to eq(200)
			expect(returned_ids).to match_array(expected_ids)
		end
	end


	post '/admin/addresses' do
		with_options scope: :address, required: true do
			parameter :city_id
			parameter :street_and_house
			parameter :door_number
			parameter :user_id
			parameter :zip_code,        required: false
		end

		example 'create own address' do
			do_request address: FactoryGirl.attributes_for(:address, city_id: city.id, user_id: user.id)

			expect(status).to eq(201)
		end

	end



	put '/admin/addresses/:id' do

		example 'change own address' do
			explanation 'fails if address has been used in any approved orders'
			do_request id: address.id, address: { street_and_house: 'good' }

			expect(status).to eq(200)
			expect(Address.find(address.id).street_and_house).to eq('good')
		end

	end

	delete '/admin/addresses/:id' do

		example 'deletes own address' do
			explanation 'marks as inactive if address has been used in any orders'

			do_request id: address.id

			expect(status).to eq(200)
			expect(Address.find_by(address.id)).to be_nil
		end

	end












end
