require 'rails_helper'

resource 'client: orders', type: :request do

	let(:user) { FactoryGirl.create :verified_user }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'


	let!(:user_order) { FactoryGirl.create :order, user_id: user.id }
	let(:product)     { FactoryGirl.create :product }

	before(:all) do
		FactoryGirl.create_list :order, 2
	end


	get '/client/orders' do
		example_request "get all current user's orders" do
			returned_ids = jsons.pluck(:id)
			expected_ids = user.orders.pluck(:id)

			expect(status).to eq(200)
			expect(returned_ids).to match_array(expected_ids)
		end

		it 'unauthenticated user - 401', document: false do
			get path
			expect_status 401 #TODO
		end
	end

	get '/client/orders/:id' do
		example "get current user's order" do
			do_request id: user_order.id

			expect(status).to eq(200)
			expect(json.keys).to include :comment,
				:id,
				:user_id,
				:status,
				:created_at,
				:comment,
				:pure_product_price,
				:tax,
				:delivery_charge,
				:total_price
		end
	end



	post 'client/orders' do
		with_options :scope => :order do
			parameter :comment,       'comment to the order'
			parameter :address_id,    '', required: true
			parameter :feedback
		end

		with_options :scope => [:order, :line_items_attributes], :required => true do
			parameter :product_id, 'id of a product in a cart'
			parameter :amount, 'amount of this product in a cart'
		end

		with_options :scope => [:order, :delivery_attributes] do
			parameter :wanted_date, 'date client wants their delivery on'
			parameter :wanted_time, "['morning', 'noon', 'evening'] time is limited between 7 am to 9 pm only, mention this in frontend"
		end

		example "create current user's order" do
			do_request( 
				order: { 
					address_id: FactoryGirl.create(:address).id,
					line_items_attributes: [
						{ product_id: product.id, amount: 1000 }
					],
					delivery_attributes: {
						wanted_date: Time.now
					}
				}
			)

			expect(status).to eq(201)
			expect(json).to include :delivery_charge=>"0.0"
		end
	end

	put 'client/orders/:id' do

		with_options :scope => :order do
			parameter :comment, 'comment to the order'
			parameter :address_id
		end

		with_options :scope => [:order, :line_items_attributes] do
			parameter :product_id, 'id of a product in a cart'
			parameter :amount, 'amount of this product in a cart'
		end

		with_options :scope => [:order, :delivery_attributes] do
			parameter :wanted_date, 'date client wants their delivery on'
			parameter :wanted_time, "['morning', 'noon', 'evening'] time is limited between 7 am to 9 pm only, mention this in frontend"
		end

		let!(:line_item_id) { user_order.line_items.first.id }


		it "update current user's order" do
			explanation <<-EXPLANATION
				we can delete order's line items and change order.
				to delete order's line item, include it's id and _destroy parameters like so.
				to update order's line item, include it's id and updated attributes.
				to create order's line item, incude it's attributes.
			EXPLANATION


			do_request({ 
				id: user_order.id,
				order: { 
					comment: 'hi',
					line_items_attributes: [
						{
							id: line_item_id, 
							_destroy: true 
						}
					]
				}
			})

			expect(status).to eq(200)
			expect(LineItem.exists? line_item_id).to be(false)
			expect(json).to include(comment: 'hi')
		end

		it "update current user's order: invalid parameters" do
			explanation "order must have at least one line item"

			do_request({ 
				id: user_order.id,
				order: { 
					comment: 'hi', 
					line_items_attributes: [
						{ 
							id: line_item_id, 
							amount: nil 
						}
					] 
				}
			})

			expect(status).to eq(422)
			expect(json).to include(:"line_items.amount"=>["can't be blank", "is not a number"])
		end

	end


	delete '/client/orders/:id' do
		example 'delete order' do
			# user_order.confirm!
			do_request id: user_order.id

			expect(status).to eq(200)
		end

		example 'delete order: after confirm' do
			user_order.confirm!
			do_request id: user_order.id

			expect(status).to eq(422)
			expect(json).to include(:order=>["can't be destroyed after confirmation, please try declining"])
		end
	end


	put '/client/orders/:id/update_status' do
		parameter :action, 'only :confirm is possible for this route (for client)', scope: :order, required: true

		example 'client confirms order' do

			do_request({
				id: user_order.id,
				order: { 
					action: 'confirm' 
				}
			})

			expect(status).to eq(200)
			expect(user_order.reload.status).to eq('confirmed')
		end


		example 'client cant approve order' do

			do_request({
				id: user_order.id,
				order: { 
					action: 'approve' 
				}
			})

			expect(status).to eq(401)
			expect(user_order.reload.status).to eq('unconfirmed')
			expect(json).to include(error: "this user can't approve order")
		end

		example 'if order is approved it cant be confirmed' do
			user_order.confirm!; user_order.approve!;
			do_request({
				id: user_order.id,
				order: { 
					action: 'confirm' 
				}
			})

			expect(status).to eq(422)
			expect(user_order.reload.status).to eq('approved')
			expect(json).to include(:status=>["status cannot transition from approved to confirm"])
		end

		it 'admin user gets 404 error (because we cant find this order in his orders)', document: false do
			@admin = FactoryGirl.create :user, abilities: ['orders']
			@admin.update(is_verified: true)
			@admin_auth_headers = @admin.create_new_auth_token
			put "/client/orders/#{user_order.id}/update_status", { order: { action: 'confirm' } }, @admin_auth_headers

			expect_status 404
		end

		example "client can't confirm order if products are out of stock" do
			product = FactoryGirl.create :product, inventory_count: 0

			order = FactoryGirl.create :order, user_id: user.id
			order.line_items.destroy_all
			order.update!(line_items_attributes: [
				{ product_id: product.id, amount: 5 }
			])

			do_request({
				id: order.id,
				order: { 
					action: 'confirm' 
				}
			})

			expect(status).to eq(422)
			expect(user_order.reload.status).to eq('unconfirmed')
			expect(product.inventory_count).to eq(0)

			expect(json.keys).to include(:'stock shortage')

			expect(json).to eq({
				:"stock shortage"=>[{
					:"product.inventory_count"=>0, 
					:"line_item.amount"=>5, 
					:"product.id"=>product.id, 
					:"line_item.id"=>order.line_items.first.id
				}]
			})

		

		end



	end






end
