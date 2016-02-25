class Coupon < ActiveRecord::Base


	validates_presence_of :name, :code, :discount

	validates :code, uniqueness: true

	validates :discount, numericality: { 
		greater_than_or_equal_to: 0
	}


end
