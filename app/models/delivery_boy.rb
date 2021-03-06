class DeliveryBoy < ActiveRecord::Base
	include AASM
	include Filterable

	belongs_to :user
	belongs_to :current_order, class_name: Order #because delivery boy chooses herself where to go

	has_many :orders

	validates_presence_of :user
	
	aasm column: :status do
		state :unavailable, :initial => true
		state :available
		state :busy

		state :fired
	end

	scope :status, -> (status)    { where status: status }
	scope :city_id, -> (city_id) {joins(:user => {:addresses => :city}).
									where( "cities.id" => city_id) }
	# scope :current_order_id




end
