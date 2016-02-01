class Admin::OrderPolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
		@current_user = current_user
		@model = model
	end

	def index?
		@current_user.has_abillity? 'orders'
	end

	def show? 
		@current_user.has_abillity? 'orders'
	end

	def create?
		@current_user.has_abillity? 'orders'
	end

	def update?
		@current_user.has_abillity? 'orders'
	end

	def destroy?
		@current_user.has_abillity? 'orders'
	end

	def update_status?
		@current_user.has_abillity? 'orders'
	end

end
