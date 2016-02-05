
class Product < ActiveRecord::Base

	has_many :categories_products_joins, inverse_of: :product, dependent: :destroy
	has_many :categories, through: :categories_products_joins
	
	accepts_nested_attributes_for :categories_products_joins, allow_destroy: true

	mount_uploader :image, ImageUploader


	has_many :orders, through: :line_items #no dependent destroy

	belongs_to :city


	validates_presence_of :price, :title, :inventory_count, :city
	#city has to be created _before_ assigning its id to product.
	validates_numericality_of :inventory_count, greater_than_or_equal_to: 0, only_integer: true


	include Filterable
	scope :city_id,      -> (city_id) { where city_id: city_id }
	scope :in_stock,     -> (true_or_false) { 
		true_or_false ? where('inventory_count > ?', 0) : where(inventory_count: 0) 
	}
	scope :category_id,  -> (category_id) { includes(:categories).where('categories.id': category_id) }


	validates_processing_of :image  # Makes the record invalid if the file couldn't be processed
	validate :image_size_validation

	# def as_json(options={})
	# 	super(methods: :'image.url')
	# end




	private
	  def image_size_validation
	    errors[:image] << "should be less than 500KB" if image.size > 0.5.megabytes #TODO actual sizes
	  end







end
