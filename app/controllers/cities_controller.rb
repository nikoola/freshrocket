class CitiesController < ApplicationController

	def index
		@cities = City.filter params.slice(:active, :containing_coordinate)
		render json: @cities, include: params[:include]
	end

	def show
		@city = City.find(params[:id])
		render json: @city, include: params[:include]
	end




end
