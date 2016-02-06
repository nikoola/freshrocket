class Admin::UsersController < ApplicationController

	before_action :set_user, only: [:show, :update, :destroy, :update_abilities, :list_abilities]
	before_action :authenticate_user!, -> { authorize User }

	# GET /users
	def index
		@users = User.all
		render json: @users
	end

	# GET /users/1
	def show
		render json: @user
	end

	# # POST /users
	# def create
	# 	@user = User.new(user_params)
	# 	if @user.save
	# 		render json: @user, status: :created, location: admin_user_path(@user)
	# 	else
	# 		render json: @user.errors, status: :unprocessable_entity
	# 	end
	# end

	# PATCH/PUT /users/1
	def update

		if @user.update(user_params)
			render json: @user, status: 200
		else
			render json: @user.errors, status: :unprocessable_entity
		end
	end

	# # DELETE /users/1
	# def destroy
	# 	@user.destroy
	# 	head 200
	# end


	def list_abilities
		hash = {}

		User::VALID_ABILITY_NAMES.each do |ability_name|
			hash[ability_name] = @user.has_abillity?(ability_name) ? 1 : 0
		end

		render json: {abilities: hash}, status: 200
	end

	def update_abilities

		params[:abilities].each do |ability_name, value|
			case value
			when '0'
				@user.ability_list.remove(ability_name)
			when '1'
				@user.ability_list.add(ability_name)
			else
				render json: 'value should be 1 or 0', status: :unprocessable_entity
			end
		end

		if @user.save
			head 200
		else
			render json: @user.errors, status: :unprocessable_entity
		end

	end

	private

		def set_user
			@user = User.find(params[:id])
		end

		def user_params
			params.require(:user).permit! #TODO
		end






end