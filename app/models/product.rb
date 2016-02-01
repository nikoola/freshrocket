
class Product < ActiveRecord::Base

	has_many :categories_products_joins, inverse_of: :product, dependent: :destroy
	has_many :categories, through: :categories_products_joins
	
	accepts_nested_attributes_for :categories_products_joins, allow_destroy: true



	has_many :orders, through: :line_items #no dependent destroy

	belongs_to :city

	has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

	validates_presence_of :price, :title, :inventory_count, :city
	#city has to be created _before_ assigning its id to product.


	include Filterable
	scope :city_id,      -> (city_id) { where city_id: city_id }
	scope :in_stock,     -> (true_or_false) { 
		true_or_false ? where('inventory_count > ?', 0) : where(inventory_count: 0) 
	}
	scope :category_id,  -> (category_id) { includes(:categories).where('categories.id': category_id) }













end
