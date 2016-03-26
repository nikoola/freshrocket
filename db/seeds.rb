


require 'factory_girl_rails'
require 'faker'


city_name = 'COIMBATORE'
area_names = ["TRICHY ROAD", "ONDIPUDUR", "VASANTHAMILL", "NEELIKONAMPALAYAM", "SINGANALLUR", "UPPILIPALAYAM", "RAMANATHA PURAM", "NANJUNDAPURAM", "SOWRIPALYAM", "PULIYAKULAM", "OLAMBUS", "SUNGAM", "TOWNHALL", "SELVAPURAM", "TELUNGUPALAYA", "GV RESIDENCY", "PALAKAD ROAD",   "KUNIYAMUTHUR", "KALAVAI", "ATHUPALAM", "POLLACHI ROAD",  "SUNDARAPURAM", "KURUCHI", "KARUMBUKADAI", "UKKADAM", "AVINASHI ROAD",  "HOPES", "THANEER PANTHAL", "MASAKALIPALAYAM", "PEELAMEDU", "NAVA INDIA", "AVARAMPALYAM", "LAKSHMI MILLS", "ANNA SILAI", "PAPANAIKAM PALAYAM", "RACE COURSE",  "SAIBABA COLONY", "BARATHI PARK", "NORTH COIMBATORE", "POOMARKET", "LOLLY ROAD", "RS.PURAM", "GANDHI PARK", "SUKRAVAR PETTAI", "SAKTHI ROAD", "GANAPATHY", "SANGANOOR", "SIDHAPUDUR", "RATHINAPURI", "TATABAD", "GANDHIPURAM", "NANJAPA ROAD", "VOC"]

puts 'creating cities'
city_1 = FactoryGirl.create :city, name: 'Helsinki'
city_2 = FactoryGirl.create :city, name: 'Paris'

puts 'creating areas'
city = City.create!(name: city_name)

area_names.each do |area_name|
	Area.create! name: area_name, city_id: city.id
end



puts 'creating admin'
FactoryGirl.create :user, email: 'admin@admin.admin', password: 'adminadminadmin', password_confirmation: 'adminadminadmin', abilities: %w(orders products users categories coupons settings cities delivery_boy)

puts 'creating verified users'
FactoryGirl.create_list :verified_user, 2

puts 'creating delivery boys'
user = FactoryGirl.create :user
user.add_ability 'delivery_boy'

puts 'creating users'
FactoryGirl.create_list :user, 2

puts 'creating cities'
FactoryGirl.create_list :city, 3


puts 'creating categories'

category_1 = FactoryGirl.create :category_with_image, name: 'Chicken'
category_2 = FactoryGirl.create :category_with_image, name: 'Lamb'
category_3 = FactoryGirl.create :category_with_image, name: 'Seafood'
category_4 = FactoryGirl.create :category_with_image, name: 'Chicken'
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
	product.categories << category_4
end
FactoryGirl.create_list(:product_with_image, 3, city_id: city_2.id, inventory_count: 0).each do |product|
	product.categories << category_3
	product.categories << category_7
end
FactoryGirl.create_list(:product, 5, inventory_count: 0).each do |product|
	product.categories << category_4
end
FactoryGirl.create_list(:product_with_image, 10, city_id: city_1.id, description: Faker::Hacker.say_something_smart).each do |product|
	product.categories << category_5
	product.categories << category_2
end




puts 'creating orders'
FactoryGirl.create_list :order, 5, comment: Faker::Hacker.say_something_smart


puts 'creating coupons'
FactoryGirl.create_list :coupon, 3





