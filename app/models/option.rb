class Option < ActiveRecord::Base
  belongs_to :line_item
  has_many :varients, dependent: :destroy
  has_many :products, through: :varients
end
