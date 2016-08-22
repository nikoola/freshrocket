class ProductsController < ApplicationController



	# GET /category/1/products
	def index
		city_id = params[:city].present? ? JSON.parse(params[:city])['id'] : nil
		@products = Product.where(city_id: city_id)
		render json: @products, include: params[:include]
	end

	# GET /category/1/products/1
	def show
		@product = Product.find(params[:id])
		render json: @product, include: params[:include]
	end




end
