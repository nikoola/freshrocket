require 'rails_helper'

resource 'admin: delivery boys', type: :request do

	let(:prohibited_user) { FactoryGirl.create :user, abilities: [:categories] }
	let(:address) { FactoryGirl.create :address, user_id: prohibited_user.id }
	let(:prohibited_auth_headers) { prohibited_user.create_new_auth_token }

	let(:user) { FactoryGirl.create :user, abilities: [:users] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'


	post '/admin/delivery_boys' do
		with_options scope: :delivery_boy do
			parameter :user_id, 'The id of user to make a delivery boy'
			parameter :statuss, "[unavailable available busy fired] - list of status"
		end

		example 'create delivery boy' do
			explanation "create Delivery boy by adding user abilibty delivery_boy"
			do_request( 
				delivery_boy: {
					user_id: prohibited_user.id,
					status: 'available'
				}
			)
			expected_ids = DeliveryBoy.where(status: 'available').pluck(:id)
			# binding.pry
			expect(expected_ids).to include(json[:id])
		end
	end
	get '/admin/delivery_boys' do
		parameter :statuss, "[unavailable available busy fired] - list of status"
		parameter :city_id, "delivery_boys in city_id"

		

		example "get available delivery boys" do
			explanation "get delivery_boys with status <available>"

			del_boys = FactoryGirl.create_list :delivery_boy, 4
			add = FactoryGirl.create :address
			del_boys.first.user.addresses = [add]
			# binding.pry
			do_request status: :available, city_id: DeliveryBoy.first.user.addresses.first.city_id

			expect(jsons.count).to be >= 0
		end
	end
	


end








