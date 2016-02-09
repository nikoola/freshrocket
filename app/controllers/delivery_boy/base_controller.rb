module DeliveryBoy
	class BaseController < ::ApplicationController

		before_action :authenticate_user!
		before_action -> { authorize 'delivery_boy' }



	end
end