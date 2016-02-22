module Admin
	class CouponsController < BaseController

		before_action :set_coupon, only: [:update, :destroy]
		before_action -> { authorize 'coupons' }

		def index
			coupons = Coupon.all
			render json: coupons
		end


		def create
			@coupon = Coupon.new(coupon_params)

			if @coupon.save
				render json: @coupon, status: :created
			else
				render json: @coupon.errors, status: :unprocessable_entity
			end
		end

		def update
			@coupon = Coupon.find(params[:id])

			if @coupon.update(coupon_params)
				render json: @coupon, status: 200
			else
				render json: @coupon.errors, status: :unprocessable_entity #422
			end
		end

		# DELETE /admin/coupons/1
		def destroy
			@coupon.destroy

			head 200
		end

		private


			def set_coupon
				@coupon = Coupon.find(params[:id])
			end

			def coupon_params
				params.require(:coupon).permit(:name, :code, :discount)
			end
	end
end