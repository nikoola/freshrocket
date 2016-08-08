module Admin
class OptionsController < ApplicationController

  #before_action :set_option, only: [:show, :update, :destroy]

  def create
    @option = Option.new(option_params)
    if @option.save
      render json: @option, status: :created, location: @option
    else
      render json: @option.errors, status: :unprocessable_entity
    end
  end

  def update
    @option = Option.find(params[:id])

    if @option.update(option_params)
      render json: @option, status: 200
    else
      render json: @option.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @option.destroy_or_disable

    head 200
  end

  private

  def set_option
    @option = Option.find(params[:id])
  end

  def option_params
    params.require(:option).permit(
        :name, :wastage
    )
  end
 end
end
