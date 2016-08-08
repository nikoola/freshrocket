


Dir[Rails.root.join('spec/fixtures/*.rb'  )].each { |f| require f }
require 'factory_girl_rails'
require 'faker'



puts 'creating cities'
city_1, city_2 = FactoryGirl.create_list :city, 2



puts 'creating admin'
FactoryGirl.create :user, email: 'admin@admin.admin', password: 'adminadminadmin', password_confirmation: 'adminadminadmin', abilities: %w(orders products users categories coupons settings cities delivery_boy), is_verified: true

puts 'creating verified users'
FactoryGirl.create_list :verified_user, 2

puts 'creating delivery boys'
user = FactoryGirl.create :user
user.add_ability 'delivery_boy'

puts 'creating users'
FactoryGirl.create_list :user, 2

puts 'creating cities'
FactoryGirl.create_list :city, 3

puts 'creating orders'
FactoryGirl.create_list :order, 5, comment: Faker::Hacker.say_something_smart

puts 'creating coupons'
FactoryGirl.create_list :coupon, 3

puts 'creating categories'

category_1 = FactoryGirl.create :category_with_image, name: 'Chicken'
category_2 = FactoryGirl.create :category_with_image, name: 'Lamb'
category_3 = FactoryGirl.create :category_with_image, name: 'Seafood'
category_5 = FactoryGirl.create :category_with_image, name: 'Matinates'
category_6 = FactoryGirl.create :category_with_image, name: 'Cold Cuts'
category_7 = FactoryGirl.create :category_with_image, name: "Today's specials"

puts 'creating products'
FactoryGirl.create_list(:product_with_image, 4, city_id: city_1.id, description: Faker::Hacker.say_something_smart).each do |product|
	product.categories << category_1
	product.categories << category_6
end
FactoryGirl.create_list(:product_with_image, 3, city_id: city_2.id).each do |product|
	product.categories << category_2
end
FactoryGirl.create_list(:product_with_image, 3, city_id: city_2.id, inventory_count: 0).each do |product|
	product.categories << category_3
	product.categories << category_7
end
FactoryGirl.create_list(:product, 5, inventory_count: 0)
FactoryGirl.create_list(:product_with_image, 10, city_id: city_1.id, description: Faker::Hacker.say_something_smart).each do |product|
	product.categories << category_5
	product.categories << category_2
end










