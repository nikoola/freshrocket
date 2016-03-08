class ProductsController < ApplicationController



	# GET /category/1/products
	def index
		@products = Product.filter params.slice(:city_id, :in_stock, :category_id)

		render json: @products, include: params[:include]
	end

	# GET /category/1/products/1
	def show
		@product = Product.find(params[:id])
		render json: @product, include: params[:include]
	end




end
