require 'rails_helper'


describe Category, type: :model do
	let(:category) { FactoryGirl.create :category }

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
	end

	it 'category is only returned once on .city_id' do
		# even when there are a few products belonging to the same city in it
		city = FactoryGirl.create :city

		FactoryGirl.create_list(:product, 3, city_id: city.id).each do |product|
			product.categories << category
		end

		returned_ids = Category.city_id(city.id).pluck(:id)
		expected_ids = Category.select { |category| 
			category.products.any? { |product| 
				product.city_id == city.id
			}
		}.pluck(:id)

		expect(returned_ids).to eq(expected_ids)
	end




	






end