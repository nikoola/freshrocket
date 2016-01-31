class Admin::ProductPolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
		@current_user = current_user
		@model = model
	end

	def create?
		@current_user.has_abillity? 'products'
	end

	def update?
		@current_user.has_abillity? 'products'
	end

	def destroy?
		@current_user.has_abillity? 'products'
	end

end
