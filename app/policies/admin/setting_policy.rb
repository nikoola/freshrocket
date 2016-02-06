class Admin::SettingPolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
		@current_user = current_user
		@model = model
	end

	def show?
		@current_user.has_abillity? 'settings'
	end

	def update?
		@current_user.has_abillity? 'settings'
	end

end
