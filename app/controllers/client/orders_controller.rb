module Client
	class OrdersController < BaseController
		# only verified user
		before_action -> { restrict_to_verified_users }, only: [:create, :update, :update_status]
		before_action :set_order, only: [:show, :update, :destroy, :update_status]

		# GET /client/orders
		def index

			@orders = current_user.orders.filter params.slice(:status)

			render json: @orders, include: params[:include]

		end

		# GET /client/orders/1
		def show
			render json: @order, include: params[:include]

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

		# DELETE /client/orders/1
		def destroy 
			if @order.unconfirmed?
				@order.destroy
				head 200
			else
				@order.errors.add(:order, "can't be destroyed after confirmation, please try calling the support")
				render json: @order.errors , status: :unprocessable_entity
			end
		end

		def update_status #@order must be current_user's
			action = params[:order][:action]
			# binding.pry
			if action.to_sym.in? [:confirm]
				@order.update_status action
				if @order.errors.empty?
					head 200
				else
					render json: @order.errors, status: :unprocessable_entity
				end
			else
				render json: { error: "this user can't #{action} order" }, status: 401
			end
		end

		def precalculate_price
			pricing = CalculateOrderPrice.new Order.new(order_params)

			json = {
				pure_product_price: pricing.pure_product_price,
				tax:                pricing.tax,
				delivery_charge:    pricing.delivery_charge,
				coupon_discount:    pricing.coupon_discount,

				total_price:        pricing.total
			}

			render json: json, status: 200
		end



		private

			def set_order
				# head status: 404 unless
				@order = current_user.orders.find_by(id: params[:id])
			end

			def order_params
				params.require(:order).permit([
					:source_type,
					:address_id,
					:coupon_code,
					:feedback,
					:comment, :wanted_date, :wanted_time,
					line_items_attributes: [:_destroy, :id, :amount, :product_id]
				])

				# no :fixed_price, :status, :user_id, :payment_type, :is_paid
			end


	end
end