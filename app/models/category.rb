
class Category < ActiveRecord::Base


	has_many :categories_products_joins, dependent: :destroy
	has_many :products, through: :categories_products_joins

	mount_uploader :image, ImageUploader

	validates :name, presence: true

	include Filterable
	scope :city_id,      -> (city_id) {
		joins(:products).where( 'products.city_id': city_id )
	}


end
