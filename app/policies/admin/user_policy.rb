class Admin::UserPolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
		@current_user = current_user
		@model = model
	end

	def index?
		@current_user.has_abillity? 'users'
	end

	def show?
		@current_user.has_abillity? 'users'
	end

	def create?
		@current_user.has_abillity? 'users'
	end

	def update?
		@current_user.has_abillity? 'users'
	end

	def destroy?
		@current_user.has_abillity? 'users'
	end

	def update_abilities? 
		@current_user.has_abillity? 'users'
	end

	def list_abilities?
		@current_user.has_abillity? 'users'
	end

end
