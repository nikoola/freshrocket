
class Category < ActiveRecord::Base


	has_many :categories_products_joins, dependent: :destroy
	has_many :products, through: :categories_products_joins

	mount_base64_uploader :image, ImageUploader

	validates :name, presence: true
	validates_processing_of :image # Makes the record invalid if the file couldn't be processed

	include Filterable
	scope :city_id,      -> (city_id) {
		joins(:products).where( 'products.city_id': city_id )
	}

	before_destroy :remove_image! #https://github.com/carrierwaveuploader/carrierwave/issues/456


end
