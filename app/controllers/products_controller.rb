class ProductsController < ApplicationController



	# GET /category/1/products
	def index
		if params[:city].present?
			city_id = JSON.parse(params[:city])['id']
			@products = Product.where(city_id: city_id)
		else
			@products = Product.filter params.slice(:city_id, :in_stock, :category_id)
		end
		render json: @products, include: params[:include]
	end

	# GET /category/1/products/1
	def show
		@product = Product.find(params[:id])
		render json: @product, include: params[:include]
	end




end
