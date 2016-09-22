class ProductsController < ApplicationController



	# GET /category/1/products
	def index
		# binding.pry
		if params[:stringified_coordinate]
			cities = getCitybyCoordinate(params[:stringified_coordinate], params[:radius].present? ? params[:radius].to_f : 200)
			render json: cities, include: [:products] and return
		end
			
		if params[:city].present?
			city_id = JSON.parse(params[:city])['id']
			@products = Product.where(city_id: city_id)
		else
			@products = Product.filter params.slice(:city_id, :in_stock, :category_id)
		end
		render json: @products, include: params[:include]
	end
	def getCitybyCoordinate stringified_coordinate,radius
		lat, lng = JSON.parse(stringified_coordinate)
		# res=Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{lat},#{lng}"   
		# # => #<Geokit::GeoLoc:0x558ed0 ...
		# # res.full_address "101-115 Main St, San Francisco, CA 94105, USA"
		# unless res.success
		# 	errors.add :city_name, "No city name"
		# end
		
		# city_name = res.city
		# unless city_name.present?
		# 	head 500
		# end
		# binding.pry
		# City.filter ({name: city_name}).first

		cities = City.containing_coordinate([lat,lng], radius)


	end
	# GET /category/1/products/1
	def show
		@product = Product.find(params[:id])
		render json: @product, include: params[:include]
	end

end
