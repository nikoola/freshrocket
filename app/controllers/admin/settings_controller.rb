class Admin::SettingsController < ApplicationController

	before_action :authenticate_user!, -> { authorize Setting }


	# GET /admin/settings
	def show
		render json: Setting.s, status: 200
	end


	# PATCH/PUT /admin/settings
	def update
		settings = Setting.s
		if settings.update settings_params
			render json: settings, status: 200
		else
			render json: settings.errors, status: :unprocessable_entity
		end
	end


	private

		def settings_params
			params.require(:settings).permit!
		end






end