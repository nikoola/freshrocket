class Address < ActiveRecord::Base

	belongs_to :user
	belongs_to :city
	has_many   :orders

	validates_presence_of :user, :city, :street_and_house, :door_number

	validate :has_no_approved_orders?, on: :update


	include Filterable
	scope :active, -> (bool) { where active: param_to_bool(bool) }




	def destroy_or_disable
		self.orders.any? ? disable : destroy
	end

	private

		def disable
			update active: false
		end

		def has_no_approved_orders?
			if self.orders.any? { |order| order.approved? }
				errors.add 'address', "can't be changed after some approved order uses it"
			end
		end



end
