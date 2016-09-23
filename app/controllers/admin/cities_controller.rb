module Admin
	class CitiesController < BaseController

		before_action :set_city, only: [:show, :update, :destroy]
		before_action -> { authorize 'cities' }

		# POST /admin/cities
		def create
			@city = City.new(city_params)

			if @city.save
				render json: @city, status: :created, location: @city, include: params[:include]
			else
				render json: @city.errors, status: :unprocessable_entity
			end
		end

		# PATCH/PUT /admin/cities/1
		def update
			@city = City.find(params[:id])

			if @city.update(city_params)
				render json: @city, status: 200, include: params[:include]
			else
				render json: @city.errors, status: :unprocessable_entity #422
			end
		end

		# DELETE /admin/cities/1
		def destroy
			@city.destroy_or_disable

			head 200
		end

		private


			def set_city
				@city = City.find(params[:id])
			end

			def city_params
				params.require(:city).permit(:name, :active, :stringified_coordinate)
			end
	end
end