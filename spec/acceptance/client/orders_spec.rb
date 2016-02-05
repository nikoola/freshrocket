require 'rails_helper'

resource 'Orders', type: :request do

	let(:user) { FactoryGirl.create :user }
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
			expect(json.keys).to match_array([:id, :user_id, :status, :fixed_price, :comment, :created_at, :updated_at])
		end
	end



	post 'client/orders' do
		with_options :scope => :order do
			parameter :comment, 'comment to the order'
		end

		with_options :scope => [:order, :line_items_attributes], :required => true do
			parameter :product_id, 'id of a product in a cart'
			parameter :amount, 'amount of this product in a cart'
		end

		let(:raw_post) do
			{ order: { line_items_attributes: [{product_id: product.id, amount: 100}] } }
		end #TODO if possible. generates ugly body.

		example_request "create current user's order" do
			expect(status).to eq(201)
			expect(json).to include(fixed_price: (product.price * 100).to_s)
		end
	end

	put 'client/orders/:id' do

		with_options :scope => :order do
			parameter :comment, 'comment to the order'
		end

		with_options :scope => [:order, :line_items_attributes], :required => true do
			parameter :product_id, 'id of a product in a cart'
			parameter :amount, 'amount of this product in a cart'
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
			expect(json).to include(:"line_items.amount"=>["can't be blank", "is not a number"], :line_items=>["is invalid"])
		end

	end


	delete '/client/orders/:id' do
		example 'delete order' do
			do_request id: user_order.id

			expect(status).to eq(200)
		end
	end


	put '/client/orders/:id/update_status' do
		parameter :action, 'only confirm is possible for this route (for client)', scope: :order, required: true

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
			@admin_auth_headers = @admin.create_new_auth_token
			put "/client/orders/#{user_order.id}/update_status", { order: { action: 'confirm' } }, @admin_auth_headers

			expect_status 404
		end
	end






end
