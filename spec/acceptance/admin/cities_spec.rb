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
			with_options scope: :areas_attributes do
				parameter :id
				parameter :name,     'area name'
				parameter :_destroy, "true/1/whatever, as long as it evaluates to true (well it's a string, so add any value). "
			end
		end

		example 'create city with areas' do
			do_request city: FactoryGirl.attributes_for(:city).merge(
				areas_attributes: [
					{ name: 'hi' }
				]
			)

			city = City.find(json[:id])
			
			expect(status).to eq(201)
			expect(json[:areas][0]).to include :id, :name
		end

	end

	put '/admin/cities/:id' do

		with_options scope: :city do
			parameter :name,     'city name', required: true
			parameter :active,   '0/1'
			with_options scope: :areas_attributes do
				parameter :id
				parameter :name,     'area name'
				parameter :_destroy, "true/1/whatever, as long as it evaluates to true (well it's a string, so add any value). "
			end
		end

		it 'update city or its areas' do
			area = FactoryGirl.create :area, city_id: city.id
			expect(city.reload.areas).to be_present

			do_request id: city.id, city: FactoryGirl.attributes_for(:city).merge(
				areas_attributes: [
					{ 
						id:       area.id,
						_destroy: 1
					}
				]
			)

			expect(status).to eq(200)
			expect(city.reload.areas).to be_blank
		end
	end

	delete '/admin/cities/:id' do

		it 'delete city' do
			explanation 'delete city if no products in it, disable it if there are products present. if city actually gets deleted, all its area will get deleted too'

			do_request id: city.id

			expect(status).to eq(200)
			expect(City.find_by(id: city.id)).to be_nil
		end


	end





end
