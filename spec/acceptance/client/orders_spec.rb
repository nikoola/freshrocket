require 'rails_helper'

RSpec.describe 'Orders', type: :request do

	before(:all) do
		@user = FactoryGirl.create :user
		@auth_headers = @user.create_new_auth_token

		@order = FactoryGirl.create :order, user_id: @user.id
	end


	describe 'GET /client/orders' do
		it 'with no params' do
			get '/client/orders', {}, @auth_headers
			ids_from_json = json_body.map {|a| a[:id]}
			ids_from_db   = @user.orders.pluck(:id)

			expect(ids_from_json).to eq(ids_from_db)
		end

		it 'unauthenticated user - 401' do
			get '/client/orders', {}
			expect_status 401
		end
	end

	it 'GET /client/orders/1' do
		get "/client/orders/#{@order.id}", {}, @auth_headers
		expect_status 200
		expect_json_keys [:id, :user_id, :status, :fixed_price, :created_at, :updated_at]
	end



	describe 'POST client/orders' do
		it 'with valid params' do
			product = FactoryGirl.create :product
			post '/client/orders', { order: { line_items_attributes: [{product_id: product.id, amount: 100}] } }, @auth_headers

			expect_status 201
			expect_json fixed_price: (product.price * 100).to_s
		end
	end

	describe 'PATCH/PUT client/orders/1' do
		it 'to delete line_items' do
			line_item = @order.line_items.first

			put "/client/orders/#{@order.id}", { 
				order: { 
					comment: 'hi', 
					line_items_attributes: [
						{ id: line_item.id, _destroy: true }
					] 
				}
			}, @auth_headers

			expect_status 200
			expect(LineItem.exists? line_item.id).to be(false)
			expect_json comment: 'hi'
		end

		it 'with invalid parameters' do
			line_item = @order.line_items.first

			put "/client/orders/#{@order.id}", { 
				order: { 
					comment: 'hi', 
					line_items_attributes: [
						{ id: line_item.id, amount: nil }
					] 
				}
			}, @auth_headers

			expect_status 422
			expect_json :"line_items.amount"=>["can't be blank"], :line_items=>["is invalid"]
		end

	end


	it 'DELETE /client/orders/1' do
		delete "/client/orders/#{@order.id}", {}, @auth_headers
		expect_status 200
	end


	describe 'PUT /client/orders/1/update_status' do
		before(:each) do
			@order = FactoryGirl.create :order, user_id: @user.id
		end

		it 'client confirms order' do
			put "/client/orders/#{@order.id}/update_status", { order: { action: 'confirm' } }, @auth_headers
			expect_status 200
			expect(@order.reload.status).to eq('confirmed')
		end

		it 'client cant approve order' do
			put "/client/orders/#{@order.id}/update_status", { order: { action: 'approve' } }, @auth_headers
			expect_status 401
			expect(@order.reload.status).to eq('unconfirmed')
			expect_json error: "this user can't approve order"
		end

		it 'if order is approved it cant be confirmed' do
			@order.confirm; @order.approve; @order.save
			put "/client/orders/#{@order.id}/update_status", { order: { action: 'confirm' } }, @auth_headers
			expect_status 422
			expect(@order.reload.status).to eq('approved')
			expect_json :status=>["status cannot transition from approved to confirm"]
		end

		it 'admin user gets 404 error (because we cant find this order in his orders)' do
			@admin = FactoryGirl.create :user, abilities: ['orders']
			@admin_auth_headers = @admin.create_new_auth_token
			put "/client/orders/#{@order.id}/update_status", { order: { action: 'confirm' } }, @admin_auth_headers

			expect_status 404
		end
	end






end
