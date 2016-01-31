class Admin::UsersController < ApplicationController

	before_action :set_user, only: [:show, :update, :destroy, :update_abilities, :list_abilities]
	before_action :authenticate_user!

	# GET /users
	def index
		authorize User #unable to find policy of nil (if nil)
		@users = User.all
		render json: @users
	end

	# GET /users/1
	def show
		authorize @user
		render json: @user
	end

	# POST /users
	def create
		authorize User
		@user = User.new(user_params)
		if @user.save
			render json: @user, status: :created, location: admin_user_path(@user)
		else
			render json: @user.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /users/1
	def update
		authorize User

		if @user.update(user_params)
			render json: @user, status: 200
		else
			render json: @user.errors, status: :unprocessable_entity
		end
	end

	# DELETE /users/1
	def destroy
		authorize User
		@user.destroy
		head 200
	end


	def list_abilities
		authorize User
		hash = {}

		User::VALID_ABILITY_NAMES.each do |ability_name|
			hash[ability_name] = @user.has_abillity?(ability_name) ? 1 : 0
		end

		render json: {abilities: hash}, status: 200
	end

	def update_abilities
		authorize User

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
			params.require(:user).permit!.except(:role) #TODO
		end






end