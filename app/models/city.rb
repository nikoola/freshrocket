class City < ActiveRecord::Base

	has_many :products

	validates :name, presence: true, uniqueness: true
	scope :active, -> (bool) { where active: param_to_bool(bool) }
	scope :name, ->(name){where name: param_to_string(name)}
	include Filterable

	def destroy_or_disable
		self.products.any? ? disable : destroy
	end



	private
		def disable
			update active: false
		end

end
