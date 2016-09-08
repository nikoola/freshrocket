require 'rails_helper'

resource 'admin: addresses', type: :request do

	let(:user) { FactoryGirl.create :user, abilities: ['users'] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:address) { FactoryGirl.create :address, user_id: user.id }
	let(:city)    { FactoryGirl.create :city }
	let(:area) {FactoryGirl.create :area, city_id: city.id}
	

	get '/admin/addresses' do
		parameter :active, '0/1. is inactive if user tried to delete order, but it was already mentioned in any orders'

		example 'get all addresses' do
			FactoryGirl.create_list :address, 3, area_id: area.id, city_id: area.city.id, user_id: user.id, active: false
			FactoryGirl.create_list :address, 2, area_id: area.id, city_id: area.city.id, user_id: user.id

			do_request active: 0

			returned_ids = jsons.pluck(:id)
			expected_ids = Address.where(active: false).pluck(:id)

			expect(status).to eq(200)
			expect(returned_ids).to match_array(expected_ids)
		end
	end


	post '/admin/addresses'  do
		with_options scope: :address, required: true do
			parameter :city_id
			parameter :street_and_house
			parameter :door_number
			parameter :user_id
			# parameter :area_id
			# parameter :lat
			# parameter :lng
			parameter :stringified_coordinate
			parameter :zip_code,        required: false
			# parameter :coordinate
		end

		example 'create address', :focus => true do
			#################################
			# add stringified_coordinate to the params
			#
			add = FactoryGirl.build(:address, area_id: area.id, city_id: area.city.id, user_id: user.id)
			hash = add.attributes
			hash[:stringified_coordinate] = "["+add.lat.to_s+","+add.lng.to_s+"]"
			# puts hash
			#####################################
			do_request address: hash	
			expect(status).to eq(201)
		end

	end



	put '/admin/addresses/:id' do

		example 'change address' do
			explanation 'fails if address has been used in any approved orders'
			do_request id: address.id, address: { street_and_house: 'good' }

			expect(status).to eq(200)
			expect(Address.find(address.id).street_and_house).to eq('good')
		end

	end

	delete '/admin/addresses/:id' do

		example 'deletes address' do
			explanation 'marks as inactive if address has been used in any orders'

			do_request id: address.id

			expect(status).to eq(200)
			expect(Address.find_by(address.id)).to be_nil
		end

	end












end
