require 'rails_helper'

resource 'admin: users', type: :request do

	let(:prohibited_user) { FactoryGirl.create :user, abilities: [:categories] }
	let(:prohibited_auth_headers) { prohibited_user.create_new_auth_token }

	let(:user) { FactoryGirl.create :user, abilities: [:users] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'


	get '/admin/users' do
		parameter :email_includes, "text included in the user's email"
		parameter :phone_includes, "text included in the user's phone"
		parameter :has_abillity,   "[orders products users categories settings delivery_boy] - list users that have following ability."

		it 'nonauthenticated - 401', document: false do
			get admin_users_path
			expect_status 401
		end

		it 'authenticated :client user - 401', document: false do
			get admin_users_path, {}, prohibited_auth_headers
			expect_status 401
		end

		example 'get all users' do
			FactoryGirl.create :user

			do_request({ has_abillity: 'users' })

			returned_ids = jsons.pluck(:id)
			expected_ids = User.has_abillity('users').pluck(:id)

			expect(status).to eq(200)
			expect(returned_ids).to match_array(expected_ids)
		end
	end

	get '/admin/users/:id' do
		it 'nonauthenticated - 401', document: false do
			get admin_user_path(user)
			expect_status 401
		end

		it 'authenticated :client user - 401', document: false do
			get admin_user_path(user), {}, prohibited_auth_headers
			expect_status 401
		end

		example 'get user' do
			do_request({id: prohibited_user.id})
			expect(status).to eq(200)
			expect(json[:abilities]).to include(:orders=>0, :products=>0, :users=>0, :categories=>1, :settings=>0)
		end
	end

	post '/admin/users' do

		with_options scope: :user do
			parameter :is_verified, 'user automatically becomes unverified on phone change unless is_verified is set to true'

			parameter :password
			parameter :password_confirmation

			parameter :phone
			parameter :email
			parameter :first_name
			parameter :last_name
			parameter :how_did_you_hear_about_us
		end

		example 'create user' do
			explanation 'create user from the admin side, and send them their password by sms'

			do_request user: FactoryGirl.attributes_for(:user)
			expect(status).to eq(201)
			expect(json.keys).to include :id, :provider, :uid, :email, :phone, :created_at
		end

		example 'by admin, with invalid params: errors returned', document: false do
			do_request user: FactoryGirl.attributes_for(:user, phone: nil)

			expect(status).to eq(422)
			expect(json[:phone]).to include "can't be blank"
		end

	end

	put '/admin/users/:id' do

		example 'update user' do
			prohibited_user.update!(is_verified: true)

			do_request({
				id: prohibited_user.id,
				user: {
					email: 'hi@hi.hey',
					phone: '+79177878978'
				}
			})

			expect(status).to eq(200)
			expect(prohibited_user.reload.is_verified).to be(false)
			expect(prohibited_user.reload.email).to eq('hi@hi.hey')
		end

		it 'update user, is_verified can be set to true', document: false do

			do_request({
				id: prohibited_user.id,
				user: {
					phone: '+79177878978',
					is_verified: 'true'
				}
			})

			expect(status).to eq(200)
			expect(prohibited_user.reload.is_verified).to be(true)
		end

		it 'update user, is_verified can doesnt change if no phone updated', document: false do
			prohibited_user.update!(is_verified: true)
			city = FactoryGirl.create(:city)

			do_request({
				id: prohibited_user.id,
				user: {
					city_id: city.id
				}
			})

			expect(status).to eq(200)
			expect(prohibited_user.reload.is_verified).to be(true)
		end
	end





	put '/admin/users/:id/update_abilities' do
		parameter :abilities, "{'users' => 1, 'products' => 0, 'orders' => 0, 'categories' => 1} - describes resource user has access to. only users with 'users' ability can update other user's abilities", required: true

		describe 'user with :users ability' do
			example 'update user abilities' do
				do_request(id: prohibited_user.id, abilities: {'users' => 1, 'products' => 0, 'orders' => 0, 'categories' => 0})

				expect(status).to eq(200)
				expect(prohibited_user.abilities.map(&:name)).to match_array(['users'])
			end

			example 'update user abilities: invalid params' do
				do_request(id: prohibited_user.id, abilities: {'lalala' => 1})

				expect(status).to eq(422)
				expect(json).to include(:abilities=>["lalala is not a valid ability"])
			end

			it 'adding :delivery_boy ability creates :delivery_boy', document: false do
				do_request(id: prohibited_user.id, abilities: {'delivery_boy' => 1})

				expect(status).to eq(200)
				expect(DeliveryBoy.last.user_id).to eq(prohibited_user.id)
			end

			it 'deleting :delivery_boy ability makes :delivery_boy fired', document: false do
				do_request(id: prohibited_user.id, abilities: {'delivery_boy' => 1})
				do_request(id: prohibited_user.id, abilities: {'delivery_boy' => 0})

				expect(status).to eq(200)
				expect(DeliveryBoy.last.user_id).to eq(prohibited_user.id)
				expect(DeliveryBoy.last.status).to eq('fired')
			end
		end

		describe 'user without :users ability' do
			it 'with valid params', document: false do
				put "/admin/users/#{prohibited_user.id}/update_abilities", {abilities: {'users' => 1, 'products' => 0, 'orders' => 0}}, @auth_headers
				expect_status 401
			end
		end


	end

end








