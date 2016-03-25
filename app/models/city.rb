class City < ActiveRecord::Base

	has_many :products

	has_many :areas, inverse_of: :city, dependent: :destroy
	accepts_nested_attributes_for :areas, allow_destroy: true #Note that the :autosave option is automatically enabled on every association that #accepts_nested_attributes_for is used for


	validates :name, presence: true, uniqueness: true

	include Filterable
	scope :active, -> (bool) { where active: param_to_bool(bool) }




	def destroy_or_disable
		self.products.any? ? disable : destroy
	end


	private
		def disable
			update active: false
		end




end
