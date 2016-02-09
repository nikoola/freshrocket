module Admin
	class CategoriesController < BaseController
		before_action :set_category, only: [:update, :destroy]
		before_action -> { authorize 'categories' }


		# POST /admin/categories
		def create
			@category = Category.new(category_params)

			if @category.save
				render json: @category, status: :created
			else
				render json: @category.errors, status: :unprocessable_entity
			end
		end

		# PATCH/PUT /admin/categories/1
		def update
			@category = Category.find(params[:id])

			if @category.update(category_params)
				render json: @category, status: 200
			else
				render json: @category.errors, status: :unprocessable_entity
			end
		end

		# DELETE /admin/categories/1
		def destroy
			@category.destroy
			head 200
		end


		private

			def set_category
				@category = Category.find(params[:id])
			end

			def category_params
				params[:category].permit([
					:name
				])
			end
	end

end