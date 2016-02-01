require 'rails_helper'


describe Category, type: :model do

	before(:each) do
		@product = FactoryGirl.create :product
		@category_1, @category_2 = FactoryGirl.create_list :category, 2
	end

	it 'puts product in 2 categories' do
		@product.categories = @category_1, @category_2
		@product.save
		expect(@product.reload.categories.count).to eq(2) 
	end

	# it 'deletes '

	it 'accepts nested categories_products_joins' do
		city = City.create! name: 'Springfield'
		product = Product.create!(FactoryGirl.attributes_for :product, city_id: city.id)
		product.update!({ categories_products_joins_attributes: [
			{category_id: @category_1.id},
			{category_id: @category_2.id}
		] })

		expect(product.reload.categories.pluck(:id)).to match_array([@category_1.id, @category_2.id])

		# product.update!({ categories_products_joins_attributes: [
		# 	{}

		# ] })

# binding.pry


	end
# delete one line_item
# add one line_item
# add multiple line_items
# delete multiple line items



	






end