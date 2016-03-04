module Admin
	class AddressesController < BaseController
		before_action :set_address, only: [:update, :destroy]
		before_action -> { authorize 'users' }

		def index
			@addresses = Address.filter params.slice(:active)

			render json: @addresses
		end

		def create
			@address = Address.new(address_params)

			if @address.save
				render json: @address, status: :created
			else
				render json: @address.errors, status: :unprocessable_entity
			end
		end

		def update #only if address.unconfirmed?
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

			def set_address
				@address = Address.find_by(id: params[:id])
			end

			def address_params
				params.require(:address).permit([
					:city_id, :user_id,
					:street_and_house, :door_number, :zip_code
				])

				# no :active
			end


	end
end