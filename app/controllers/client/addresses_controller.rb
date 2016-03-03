module Client
	class AddressesController < BaseController

		before_action :set_address, only: [:update, :destroy]

		# GET /client/addresses
		def index
			@addresses = current_user.addresses.filter params.slice(:active)

			render json: @addresses
		end

		# POST /client/addresses
		def create
			@address = current_user.addresses.new(address_params)

			if @address.save
				render json: @address, status: :created
			else
				render json: @address.errors, status: :unprocessable_entity
			end
		end

		# PATCH/PUT /client/addresses/1
		def update #only if address.unconfirmed?
			if @address.update(address_params)
				render json: @address, status: 200
			else
				render json: @address.errors, status: :unprocessable_entity
			end
		end

		# DELETE /client/addresses/1
		def destroy 
			@address.destroy_or_disable
			head 200
		end



		private

			def set_address
				head status: 404 unless @address = current_user.addresses.find_by(id: params[:id])
			end

			def address_params
				params.require(:address).permit([
					:city_id, 
					:street_and_house, :door_number
				])

				# no :user_id, :active
			end


	end
end