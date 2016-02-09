module Client
	class OrdersController < BaseController
		before_action :set_order, only: [:show, :update, :destroy, :update_status]

		# GET /client/orders
		def index
			@orders = current_user.orders.filter params.slice(:status)

			render json: @orders
		end

		# GET /client/orders/1
		def show
			render json: @order
		end

		# POST /client/orders
		def create 
			@order = current_user.orders.new(order_params)

			if @order.save
				render json: @order, status: :created, location: client_order_path(@order)
			else
				render json: @order.errors, status: :unprocessable_entity
			end
		end

		# PATCH/PUT /client/orders/1
		def update #only if order.unconfirmed?
			if @order.update(order_params)
				render json: @order, status: 200
			else
				render json: @order.errors, status: :unprocessable_entity
			end
		end

		# # DELETE /client/orders/1
		# def destroy #only if order.unconfirmed?
		# 	@order.destroy
		# 	head 200
		# end

		def update_status #@order must be current_user's
			action = params[:order][:action]
			# binding.pry
			if action.to_sym == :confirm
				@order.update_status action
				if @order.errors.empty?
					head 200
				else
					render json: @order.errors, status: :unprocessable_entity
				end
			else
				render json: {error: "this user can't #{action} order"}, status: 401
			end
		end



		private

			def set_order
				head status: 404 unless @order = current_user.orders.find_by(id: params[:id])
			end

			def order_params
				params.require(:order).permit([
					:comment,
					delivery_attributes: [:id, :wanted_date, :wanted_time],
					line_items_attributes: [:_destroy, :id, :amount, :product_id]
				])

				# no :fixed_price, :status, :user_id
			end
	end
end