module Admin
	class AddressesController < BaseController
		#stringified_coordinate
		def containing_address
			#@address = Address.new(address_params)
			coordinate = JSON.parse(address_params[:stringified_coordinate])
			res = Area.containing_coordinate(coordinate)
			if res
				head 200
			else
				render json: "Not reachable address.", status: 400
			end
		end
		private

			def address_params
				params.require(:address).permit([
					:city_id, :user_id,
					:street_and_house, :door_number, :zip_code, :stringified_coordinate
				])

				# no :active
			end
	end
end