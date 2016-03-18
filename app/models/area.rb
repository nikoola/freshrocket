class Area < ActiveRecord::Base

	belongs_to :city

	validates :name, presence: true, uniqueness: true
	validates_presence_of :city

end
