class CitiesController < ApplicationController

	def index
		@cities = City.filter params.slice(:active)

		render json: @cities
	end

	def show
		@product = City.find(params[:id])
		render json: @product
	end




end
