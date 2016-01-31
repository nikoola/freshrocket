
class Product < ActiveRecord::Base

	# has_many :users, through: :orders

	# has_many :line_items
	has_many :orders, through: :line_items

	belongs_to :city

	has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

	validates :price, :title, :inventory_count, :city, 
		presence: true
	#city has to be created _before_ assigning its id to product.


	include Filterable
	scope :city_id,  -> (city_id) { where city_id: city_id }
	scope :in_stock, -> (true_or_false) { 
		true_or_false ? where('inventory_count > ?', 0) : where(inventory_count: 0) 
	}
	# scope :starts_with, -> (name) { where("name like ?", "#{name}%")}

end
