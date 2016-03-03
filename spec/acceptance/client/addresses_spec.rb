require 'rails_helper'

resource 'client: addresses', type: :request do

	let(:user) { FactoryGirl.create :user }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:address) { FactoryGirl.create :address, user_id: user.id }
	let(:city)    { FactoryGirl.create :city }

	get '/client/addresses' do
		parameter :active, '0/1. is inactive if user tried to delete order, but it was already mentioned in any orders'

		example 'get all own addresses' do
			FactoryGirl.create_list :address, 3, user_id: user.id, active: false
			FactoryGirl.create_list :address, 2, user_id: user.id
			FactoryGirl.create_list :address, 2

			do_request active: 0

			returned_ids = jsons.pluck(:id)
			expected_ids = user.addresses.where(active: false).pluck(:id)

			expect(status).to eq(200)
			expect(returned_ids).to match_array(expected_ids)
		end
	end


	post '/client/addresses' do
		with_options scope: :address, required: true do
			parameter :city_id
			parameter :order_id
			parameter :street_and_house
			parameter :door_number
		end

		example 'create own address' do
			do_request address: FactoryGirl.attributes_for(:address, city_id: city.id)

			expect(status).to eq(201)
			expect(json[:user_id]).to eq(user.id)
		end

	end



	put '/client/addresses/:id' do

		example 'change own address' do
			explanation 'fails if address has been used in any approved orders'
			do_request id: address.id, address: { street_and_house: 'good' }

			expect(status).to eq(200)
			expect(Address.find(address.id).street_and_house).to eq('good')
		end

	end

	delete '/client/addresses/:id' do

		example 'deletes own address' do
			explanation 'marks as inactive if address has been used in any orders'

			do_request id: address.id

			expect(status).to eq(200)
			expect(Address.find_by(address.id)).to be_nil
		end

	end












end
