require 'rails_helper'

resource "admin: areas", type: :request do
	let(:user) { FactoryGirl.create :user, abilities: ['cities'] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:city)    { FactoryGirl.create :city }
	let(:area) { FactoryGirl.create :area, city_id: city.id }
	

	get '/admin/areas' do
		parameter :active, '0/1. is inactive if user tried to delete order, but it was already mentioned in any orders'

		example 'get all areas', :focus => true do
			FactoryGirl.create_list :area, 3, city_id: city.id, active: false
			FactoryGirl.create_list :area, 2, city_id: city.id

			do_request active: 0

			returned_ids = jsons.pluck(:id)
			expected_ids = Area.where(active: false).pluck(:id)

			expect(status).to eq(200)
			expect(returned_ids).to match_array(expected_ids)
		end
	end


	post '/admin/areas' do
		with_options scope: :area, required: true do
			parameter :city_id
			parameter :stringified_coordinate
			parameter :radius
			parameter :name
			parameter :active

		end

		example 'create areas' do
			#################################
			# add stringified_coordinate to the params
			#
			add = FactoryGirl.build(:area, city_id: area.city.id)
			hash = add.attributes
			hash[:stringified_coordinate] = "["+add.lat.to_s+","+add.lng.to_s+"]"
			# puts hash
			#####################################
			do_request area: hash
			expect(status).to eq(201)
		end

	end



	put '/admin/areas/:id' do

		example 'change areas' do
			explanation 'fails if area has been used in any approved orders'
			do_request id: area.id, area: { name: 'good' }

			expect(status).to eq(200)
			expect(Area.find(area.id).name).to eq('good')
		end

	end

	delete '/admin/areas/:id' do

		example 'deletes areas' do
			explanation 'marks as inactive if area has been used in any orders'

			do_request id: area.id

			expect(status).to eq(200)
			expect(Area.find_by(area.id)).to be_nil
		end

	end


end