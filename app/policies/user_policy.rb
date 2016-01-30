class UserPolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
		@current_user = current_user
		@model = model
	end

	def index?
		@current_user.admin?
	end

	def show? #allow self users too as they don't have the registration#show in default ng routes
		(@current_user.client? and model == @current_user) or @current_user.admin?
	end

	def create?
		@current_user.admin?
	end

	def update?
		@current_user.admin?
	end

	def destroy?
		@current_user.admin?
	end

end
