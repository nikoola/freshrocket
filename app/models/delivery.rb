class Delivery < ActiveRecord::Base
	#doesn't exist out of order context

	belongs_to :order
	belongs_to :delivery_boy, class_name: 'User'#, inverse_of: :delivery

	DELIVERY_TIMES = ['morning', 'noon', 'evening']
	validates_inclusion_of :wanted_time, in: DELIVERY_TIMES, allow_blank: true, message: "%{value} is not permitted. can be #{DELIVERY_TIMES}"

end
