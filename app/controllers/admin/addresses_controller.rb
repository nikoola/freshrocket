module Admin
	class AddressesController < BaseController
		before_action :set_address, only: [:update, :destroy]
		before_action -> { authorize 'orders' }

		def index
			
		end

		def create
			@address = Address.new(address_params)

			if @address.save
				render json: @address, status: :created
			else
				render json: @address.errors, status: :unprocessable_entity
			end
		end

		def update
			@address = Address.find(params[:id])

			if @address.update(address_params)
				render json: @address, status: 200
			else
				render json: @address.errors, status: :unprocessable_entity
			end
		end

		def destroy
			@address.destroy_or_disable
			head 200
		end


		private

			def set_user
				@user = User.find(params[:user_id])
				
			end

			def set_address

				@address = Address.find(params[:id])
			end

			def address_params
				params.require(:address).permit([
					:city_id,
					:street_and_house, :door_number, :zip_code
				])

				# no :user_id, :active
			end
	end

end