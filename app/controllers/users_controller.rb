class UsersController < ApplicationController

	before_action :for_admins, only: [:create, :update, :destroy]


	# GET /products or products.json
	def index
		@products = Product.filter params.slice(:city_id, :in_stock)

		render json: @products
	end

	# GET /products/1
	def show
		render json: @product
	end

	# POST /users
	def create
		user = User.new(user_params)
		if user.save && user.create_login(login_params)
			head 200
		else
			head 422 # you'd actually want to return validation errors here
		end
	end


	# PATCH/PUT /products/1
	def update
		@product = Product.find(params[:id])

		if @product.update(product_params)
			head 200
		else
			render json: @product.errors, status: :unprocessable_entity
		end
	end

	# DELETE /products/1
	def destroy
		@product.destroy

		head 200
	end



	private

		def user_params
			params.require(:user).permit! #TODO
		end

		def login_params
			params.require(:user).permit(:identification, :password, :password_confirmation)
		end

end