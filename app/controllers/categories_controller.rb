class CategoriesController < ApplicationController


	# GET /categories or categories.json
	def index
		@categories = Category.filter params.slice(:city_id) #categories with products from city_id. categories with products in stock.

		render json: @categories
	end


end
