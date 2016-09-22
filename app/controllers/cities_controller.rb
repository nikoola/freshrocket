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
	    # binding.pry
	    
	    render json: res
  	end
  	
  	def recommend_areas
  		# binding.pry
  		client =  GooglePlacesAutocomplete::Client.new(:api_key => Rails.application.secrets['google_place_api_key'])
		autocomplete = client.autocomplete(:input => params[:input], :types => "geocode",
		 :lat => 40.606654, :lng => 14.036865, :radius => 0, :components => 'country:in')
		# unless autocomplete[:predictions].count
		# 	exit
		# end
		binding.pry
		res = []
		autocomplete.parsed_response["predictions"].each { |x|
			# binding.pry
				details = client.details(:placeid => x["place_id"])
				details = details["result"]
				# binding.pry
			# one = []
			formatted_add = details["formatted_address"]
			lat = details["geometry"]["location"]["lat"]
			lng = details["geometry"]["location"]["lng"]
			one = {:address => formatted_add, :lat => lat, :lng => lng}
			res << one
		}
		# res
  		# res = City.recommend_areas(params.slice(:id, :input))
  		render json: res
  	end


end
