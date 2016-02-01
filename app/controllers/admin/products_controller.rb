class Admin::ProductsController < ApplicationController

	before_action :set_product, only: [:show, :update, :destroy]
	before_action :authenticate_user!, -> { authorize Product }



	# POST /admin/products
	def create
		# @categories = Category.where(id: params[:product_params][:category_ids])
		
		@product = Product.new(product_params)
		# @product.categories = @categories
		if @product.save
			render json: @product, status: :created, location: @product
		else
			render json: @product.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /admin/products/1
	def update
		@product = Product.find(params[:id])

		if @product.update(product_params)
			render json: @product, status: 200
		else
			render json: @product.errors, status: :unprocessable_entity #422
		end
	end

	# DELETE /admin/products/1
	def destroy
		@product.destroy

		head 200
	end

	private


		def set_product
			@product = Product.find(params[:id])
		end

		def product_params
			params.require(:product).permit(:title, :price, :inventory_count, :city_id, category_ids: [])
		end
end
