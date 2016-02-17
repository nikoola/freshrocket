class DeliveryBoy < ActiveRecord::Base
	include AASM
	include Filterable

	belongs_to :user

	has_many :orders

	aasm column: :status do
		state :unavailable, :initial => true
		state :available
		state :busy

		state :fired
	end

	scope :status, -> (status)    { where status: status }




end
