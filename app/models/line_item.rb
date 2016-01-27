class LineItem < ActiveRecord::Base


	belongs_to :order
	belongs_to :product

	validates :order, :product, presence: true


end
