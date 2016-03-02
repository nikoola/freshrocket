module Admin
	class OrdersController < BaseController
		before_action :set_order, only: [:show, :update, :destroy, :update_status]
		before_action -> { authorize 'orders' }

		# GET /admin/orders
		def index
			@orders = Order.filter params.slice(:city_id, :user_id, :status, :limit, :offset)

			render json: @orders
		end

		# GET /admin/orders/1
		def show
			render json: @order, status: 200
		end

		def create
			@order = Order.new order_params
			if @order.confirm! and @order.approve!
				render json: @order, status: :created
			else
				render json: @order.errors, status: :unprocessable_entity
			end
		end

		# PATCH/PUT /admin/orders/1
		def update
			if @order.update(order_params)
				render json: @order, status: 200
			else
				render json: @order.errors, status: :unprocessable_entity
			end
		end



		def update_status
			action = params[:order][:action]

			if action.to_sym.in? [:approve, :dispatch, :cancel, :delivered] #boss asked for delivered
				@order.update_status action
				if @order.errors.blank?
					head 200
				else
					render json: @order.errors, status: :unprocessable_entity
				end
			else
				render json: { error: "this user can't #{action} order" }, status: 401
			end

		end

		private

			def set_order
				@order = Order.find(params[:id])
			end

			def order_params
				params.require(:order).permit([
					:delivery_boy_id, :user_id, :address_id,
					:coupon_code,
					:feedback,
					:comment, :wanted_date, :wanted_time,
					line_items_attributes: [:_destroy, :id, :amount, :product_id]
				])

				# no payment_type (it's set automatically)
			end
	end

end




