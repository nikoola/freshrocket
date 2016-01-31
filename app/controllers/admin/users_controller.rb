class Admin::UsersController < ApplicationController

	before_action :set_user, only: [:show, :update, :destroy]
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

		@user = User.find(params[:id])

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

	private

		def set_user
			@user = User.find(params[:id])
		end

		def user_params
			params.require(:user).permit!.except(:role) #TODO
		end






end