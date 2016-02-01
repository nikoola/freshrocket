class CategoriesController < ApplicationController

	before_action :set_category, only: [:show]


	# GET /categories or categories.json
	def index
		@categories = Category.filter params.slice(:city_id, :in_stock) #categories with products from city_id. categories with products in stock.

		render json: @categories
	end


	private

		def set_category
			@category = Category.find(params[:id])
		end

		def category_params
			params.require(:category).permit(:name)
		end
end
