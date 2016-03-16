
class Product < ActiveRecord::Base

	mount_base64_uploader :image, ImageUploader
	before_destroy :remove_image! #https://github.com/carrierwaveuploader/carrierwave/issues/456


	has_many :categories_products_joins, inverse_of: :product, dependent: :destroy
	has_many :categories, through: :categories_products_joins
	
	accepts_nested_attributes_for :categories_products_joins, allow_destroy: true


	has_many :line_items
	has_many :orders, through: :line_items #no dependent destroy

	belongs_to :city


	validates_presence_of :price, :title, :inventory_count, :city
	#city has to be created _before_ assigning its id to product.
	validates_numericality_of :inventory_count, greater_than_or_equal_to: 0, only_integer: true


	include Filterable
	scope :city_id,      -> (city_id) { where city_id: city_id }
	scope :in_stock,     -> (bool) { 
		if bool.to_s == '1' 
			where('inventory_count > ?', 0)
		elsif bool.to_s == '0'
			where(inventory_count: 0)
		end
	}
	scope :category_id,  -> (category_id) { joins(:categories).where('categories.id': category_id) }


	validates_processing_of :image # Makes the record invalid if the file couldn't be processed
	validate :image_size_validation





	def destroy_or_disable
		self.orders.any? ? disable : destroy
	end

	def disable
		update inventory_count: 0
	end






	private
	  def image_size_validation
	    errors[:image] << "should be less than 4MB" if image.size > 4.megabytes
	  end







end
