class Order < ActiveRecord::Base
  belongs_to :user

  has_many :line_items
  # has_many   :products, through: :line_items

  accepts_nested_attributes_for :line_items

  # validates :user, presence: true #TODO


  def get_price
  	self.line_items.each do |line_item|
  		
  	end
  	
  end
end









