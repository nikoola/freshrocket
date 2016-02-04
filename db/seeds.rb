


require 'factory_girl_rails'
require 'faker'

puts 'creating users'
FactoryGirl.create_list :user, 5

puts 'creating cities'
FactoryGirl.create_list :city, 3


puts 'creating categories'
city_1, city_2 = FactoryGirl.create_list :city, 2
category_1, category_2 = FactoryGirl.create_list :category, 2

puts 'creating products'
FactoryGirl.create_list(:product, 4, city_id: city_1.id).each do |product|
	product.categories << category_1
end
FactoryGirl.create_list(:product, 3, city_id: city_2.id).each do |product|
	product.categories << category_2
end
FactoryGirl.create_list(:product, 3, city_id: city_2.id, inventory_count: 0).each do |product|
	product.categories << category_2
end
FactoryGirl.create_list :product, 5, inventory_count: 0



puts 'creating orders'
10.times do
	FactoryGirl.create :order, 10, comment: Faker::Hacker.say_something_smart
end






