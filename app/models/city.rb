class City < ActiveRecord::Base

	has_many :products

	validates :name, presence: true, uniqueness: true
	scope :active, -> (bool) { where active: param_to_bool(bool) }
	
end
