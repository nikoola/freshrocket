require 'rails_helper'

resource 'admin: cities', type: :request do

	let(:user) { FactoryGirl.create :user, abilities: [:cities] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:city) { FactoryGirl.create :city }

	post '/admin/cities' do
		with_options scope: :city do
			parameter :name,     'city name', required: true
			parameter :active,   '0/1'
			parameter :stringified_coordinate
			#parameter :stringified_polygon, '[[10, 50], ...], where 10 is lat, and 50 is lng of the first point of polygon'
		end

		example 'create city' do
			#################################
			# add stringified_coordinate to the params
			#
			city = FactoryGirl.build(:city)
			hash = city.attributes
			hash[:stringified_coordinate] = "["+city.lat.to_s+","+city.lng.to_s+"]"
			# puts hash
			#####################################
			do_request city: hash, include: [:products]
			expect(status).to eq(201)
		end

	end

	put '/admin/cities/:id' do

		it 'update city' do
			do_request id: city.id, city: {
				name: 'hi'
			}

			expect(status).to eq(200)
			expect(city.reload.name).to eq('hi')
		end
	end

	delete '/admin/cities/:id' do

		it 'delete city' do
			explanation 'delete city if no products in it, disable it if there are products present'

			do_request id: city.id

			expect(status).to eq(200)
			expect(City.find_by(id: city.id)).to be_nil
		end


	end





end
