module Admin
	class StatsController < BaseController
		before_action -> { authorize 'orders' }


		def stats
			
			json = {
				orders: {
					'today':       Order.where("created_at >= ?", 1.day.ago) .count,
					'this week':   Order.where("created_at >= ?", 1.week.ago).count,
					'unconfirmed': Order.unconfirmed                         .count,
					'confirmed':   Order.confirmed                           .count,
					'approved':    Order.approved                            .count,
					'dispatched':  Order.dispatched                          .count,
					'delivered':   Order.delivered                           .count,
					'canceled':    Order.canceled                            .count
				},
				users: {
					'all': User.count
				}
			}

			render json: json

		end

	end
end