class ProductsController < ApplicationController

	before_action :set_product, only: [:show, :update, :destroy]
	before_action :authenticate_user!, only: [:create, :update, :destroy]


	# GET /products or products.json
	def index
		@products = Product.filter params.slice(:city_id, :in_stock)

		render json: @products
	end

	# GET /products/1
	def show
		render json: @product
	end


	private

		def set_product
			@product = Product.find(params[:id])
		end

		def product_params
			params.require(:product).permit! #TODO
		end
end
