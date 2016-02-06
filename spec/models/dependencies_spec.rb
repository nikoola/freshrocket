require 'rails_helper'


describe ActiveRecord::Base, type: :model do

	before(:each) do
		@product = FactoryGirl.create :product
		@category_1, @category_2 = FactoryGirl.create_list :category, 2
	end

	describe 'dependent: :destroy' do

		describe 'Category Product CategoriesProductsJoin' do
			let!(:category){ FactoryGirl.create :category }
			let!(:product){ FactoryGirl.create :product }
			let!(:join){ CategoriesProductsJoin.create!( category_id: category.id, product_id: product.id) }

			it 'category destroyed ---> categories_products_joins destroyed, product stays' do
				category.destroy!
				expect(Product.find_by(id: product.id)).to be_present
				expect(CategoriesProductsJoin.find_by(id: join.id)).to be_nil
			end

			it 'product destroyed ---> categories_products_joins destroyed, category stays' do
				product.destroy!
				expect(Category.find_by(id: category.id)).to be_present
				expect(CategoriesProductsJoin.find_by(id: join.id)).to be_nil
			end

			it 'categories_products_joins destroyed ---> product stays, category stays' do
				join.destroy!
				expect(Category.find_by(id: category.id)).to be_present
				expect(Product.find_by(id: product.id)).to be_present
			end
		end

		describe 'LineItem Product Order' do
			let!(:order){ FactoryGirl.create :order }
			
			it 'order destroyed ---> line_items destroyed, product stays' do
				line_item_ids = order.line_items.pluck(:id)
				product_ids = order.products.pluck(:id)

				order.destroy!
				expect(LineItem.where(id: line_item_ids)).to all( be_nil )
				expect(Product.where(id: product_ids)).to all( be_present )
			end



		end

	end




end