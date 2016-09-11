class CitiesController < ApplicationController

	def index
		@cities = City.filter params.slice(:active, :name)
		render json: @cities, include: params[:include]
	end

	def show
		@city = City.find(params[:id])
		render json: @city, include: params[:include]
	end

	def containing_areas
	    # res  = Area.containing_area( params[:name])
	    # binding.pry
	    # byebug
	    res = Area.filter :city_id => params[:id]
	    render json: res
  	end



end
