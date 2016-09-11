class AreasController < ApplicationController
  before_action :set_area, only: [:show]

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_area
      @area = Area.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def area_params
      params.require(:area).permit(:name, :city_id)
    end
end
