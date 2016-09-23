module Admin
	class OrdersController < BaseController
		before_action :set_order, only: [:show, :update, :destroy, :update_status, :send_confirmation_sms_and_email_summay]
		before_action -> { authorize 'orders' }

		# GET /admin/orders
		def index
			city_id = params[:city_id]#params[:city].present? ? JSON.parse(params[:city])['id'] : nil
							# binding.pry

			if city_id && Address.get_address_by_city_id(city_id)
				@orders = Address.get_address_by_city_id(city_id).orders
				render json: @orders, include: params[:include]
			else
				render json:[]
			end
		end

		# GET /admin/orders/1
		def show
			render json: @order, include: params[:include]
		end

		def create
			# binding.pry
			@order = Order.new order_params

			if @order.confirm! and @order.approve!
				render json: @order, status: :created
			else
				render json: @order.errors, status: :unprocessable_entity
			end
		end

		# PATCH/PUT /admin/orders/1
		def update
			# binding.pry
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
		def send_confirmation_sms_and_email_summay
			# binding.pry
			unless @order.present?
				render json: { errors: 'no Order with such id' }, status: 422
			end
			ClientMailer.order_summary(@order).deliver_later
			SendConfirmationSmsJob.perform_later @order.user.name, @order.user.phone
			head 200
		end
		private


			def set_order
				@order = Order.find(params[:id])
			end

			def order_params
				params.require(:order).permit([
					:source_type,
					:delivery_boy_id, :user_id, :address_id,
					:coupon_code,
					:feedback, :comment, :admin_comment,
					:wanted_date, :wanted_time,
					line_items_attributes: [:_destroy, :id, :amount, :product_id]
				])

				# no payment_type (it's set automatically)
			end
	end

end




