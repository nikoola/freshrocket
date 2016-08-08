class OptionsController < ApplicationController

  def show
    @option = Option.find(params[:id])
    render json: @option, include: params[:include]
  end

  def index
    @option = Option.all
    render json: @option, include: params[:include]
  end

 # private

  #def option_params
    #params.require(:option).permit(
    #    :name, :wastage
    #)
  #end
end

