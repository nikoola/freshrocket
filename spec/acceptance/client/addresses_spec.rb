require 'rails_helper'

resource 'client: addresses', type: :request do

	let(:user) { FactoryGirl.create :user }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:address) { FactoryGirl.create :address, user_id: user.id }
	let(:city)    { FactoryGirl.create :city }
	let(:area) {FactoryGirl.create :area, city_id: city.id}

	get '/client/addresses' do
		parameter :active, '0/1. is inactive if user tried to delete order, but it was already mentioned in any orders'

		example 'get all own addresses' do
			FactoryGirl.create_list :address, 3, area_id: area.id, city_id: city.id, user_id: user.id, active: false
			FactoryGirl.create_list :address, 2, area_id: area.id, city_id: city.id, user_id: user.id
			FactoryGirl.create_list :address, 2, area_id: area.id, city_id: city.id, user_id: user.id

			do_request active: 0

			returned_ids = jsons.pluck(:id)
			expected_ids = user.addresses.where(active: false).pluck(:id)

			expect(status).to eq(200)
			expect(returned_ids).to match_array(expected_ids)
			#expect(jsons[0].keys).to include :zip_code
			expect(jsons[0][:city_name]).to eq(Address.find(jsons[0][:id]).city.name)
		end
	end


	post '/client/addresses' do
		with_options scope: :address, required: true do
			parameter :city_id
			# parameter :area_id
			parameter :street_and_house
			parameter :door_number
			parameter :lat
			parameter :lng
			parameter :zip_code,        required: false
		end

		example 'create own address' do
			do_request address: FactoryGirl.attributes_for(:address, city_id: city.id, area_id: area.id)

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
