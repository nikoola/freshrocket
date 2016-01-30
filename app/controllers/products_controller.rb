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

	# POST /products
	def create
		authorize Product
		@product = Product.new(product_params)
		if @product.save
			render json: @product, status: :created, location: @product
		else
			render json: @product.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /products/1
	def update
		authorize Product
		@product = Product.find(params[:id])

		if @product.update(product_params)
			head 200
		else
			render json: @product.errors, status: :unprocessable_entity
		end
	end

	# DELETE /products/1
	def destroy
		authorize Product
		@product.destroy

		head 200
	end

	private

		def set_product
			@product = Product.find(params[:id])
		end

		def product_params
			params.require(:product).permit! #TODO
		end
end
