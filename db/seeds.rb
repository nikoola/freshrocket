


require 'factory_girl_rails'
require 'faker'


city = 'COIMBATORE'
areas = ["TRICHY ROAD", "ONDIPUDUR", "VASANTHAMILL", "NEELIKONAMPALAYAM", "SINGANALLUR", "UPPILIPALAYAM", "RAMANATHA PURAM", "NANJUNDAPURAM", "SOWRIPALYAM", "PULIYAKULAM", "OLAMBUS", "SUNGAM", "TOWNHALL", "SELVAPURAM", "TELUNGUPALAYA", "GV RESIDENCY",    "PALAKAD ROAD",   "KUNIYAMUTHUR", "KALAVAI", "ATHUPALAM", "POLLACHI ROAD",  "SUNDARAPURAM", "KURUCHI", "ATHUPALAM", "KARUMBUKADAI", "UKKADAM", "AVINASHI ROAD",  "HOPES", "THANEER PANTHAL", "MASAKALIPALAYAM", "PEELAMEDU", "NAVA INDIA", "AVARAMPALYAM", "LAKSHMI MILLS", "ANNA SILAI", "PAPANAIKAM PALAYAM", "UPPILIPALAYAM", "RACE COURSE",  "SAIBABA COLONY", "BARATHI PARK", "NORTH COIMBATORE", "POOMARKET", "LOLLY ROAD", "RS.PURAM", "GANDHI PARK", "SUKRAVAR PETTAI", "SAKTHI ROAD", "GANAPATHY", "SANGANOOR", "SIDHAPUDUR", "RATHINAPURI", "TATABAD", "GANDHIPURAM", "NANJAPA ROAD", "VOC"]

puts 'creating cities'
city_1, city_2 = FactoryGirl.create_list :city, 2

puts 'creating areas'
city = City.new(name: city)

areas.each do |area|
	Area.create name: area, city_id: city.id
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
category_1, category_2 = FactoryGirl.create_list :category_with_image, 2

puts 'creating products'
FactoryGirl.create_list(:product_with_image, 4, city_id: city_1.id, description: Faker::Hacker.say_something_smart).each do |product|
	product.categories << category_1
end
FactoryGirl.create_list(:product_with_image, 3, city_id: city_2.id).each do |product|
	product.categories << category_2
end
FactoryGirl.create_list(:product_with_image, 3, city_id: city_2.id, inventory_count: 0).each do |product|
	product.categories << category_2
end
FactoryGirl.create_list :product, 5, inventory_count: 0



puts 'creating orders'
FactoryGirl.create_list :order, 5, comment: Faker::Hacker.say_something_smart


puts 'creating coupons'
FactoryGirl.create_list :coupon, 3





