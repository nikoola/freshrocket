
class Category < ActiveRecord::Base


	has_many :categories_products_joins
	has_many :products, through: :categories_products_joins, dependent: :destroy


	validates :name, presence: true

	include Filterable
	scope :city_id,      -> (city_id) { includes(:products).where('products.city_id': city_id) }
	scope :in_stock,     -> (true_or_false) { 
		if true_or_false 
			includes(:products).where('products.inventory_count > ?', 0) 
		else
			includes(:products).where(inventory_count: 0) 
		end
	}

end
