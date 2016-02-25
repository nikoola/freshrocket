require 'rails_helper'

resource 'Coupons', type: :request do

	let(:user) { FactoryGirl.create :user, abilities: [:coupons] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:coupon) { FactoryGirl.create :coupon }


	get '/admin/coupons' do

		example 'get all coupons' do
			coupons = FactoryGirl.create_list :coupon, 4
			do_request


			expect(status).to eq(200)
			expect(jsons[0].keys).to match_array([:id, :name, :code, :discount])
		end
	end

	post '/admin/coupons' do

		with_options scope: :coupon do
			parameter :name,     'name of the coupon'
			parameter :code,     'code for checking if client has discount'
			parameter :discount, 'discount'
		end

		example 'create coupon' do
			do_request(
				coupon: {
					name:     'red',
					code:     '181513',
					discount: '5'
				}
			)

			expect(status).to eq(201)
			expect(json).to include :id, :name, :code, :discount
		end

	end

	put '/admin/coupons/:id' do

		with_options scope: :coupon do
			parameter :name,     'name of the coupon'
			parameter :code,     'code for checking if client has discount'
			parameter :discount, 'discount'
		end

		example 'update coupon' do
			do_request(
				id:    coupon.id,
				coupon: {
					name: 'green'
				}
			)

			expect(status).to eq(200)
			expect(coupon.reload.name).to eq('green')
		end

	end


	delete '/admin/coupons/:id' do

		example 'delete coupon' do
			do_request(
				id: coupon.id
			)

			expect(status).to eq(200)
			expect(Coupon.find_by(coupon.id)).to be(nil)
		end

	end



end








