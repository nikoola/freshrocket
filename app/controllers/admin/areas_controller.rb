module Admin
  class AreasController < BaseController
    before_action :set_area, only: [:show, :edit, :update, :destroy]
    before_action -> { authorize 'cities' }
    # GET /areas
    def index
      @area = Area.filter params.slice(:active)

      render json: @area
    end

    # GET /areas/1
    def show
    end

    # Post /areas
    def create
      @area = Area.new(area_params)

      if @area.save
        render json: @area, status: :created
      else
        render json: @area.errors, status: :unprocessable_entity
      end
    end


    # PATCH/PUT /areas/1
    def update
      if @area.update(area_params)
        render json: @area, status: 200
      else
        render json: @area.errors, status: :unprocessable_entity
      end
    end

    # DELETE /areas/1
    def destroy
      @area.destroy_or_disable
      head 200
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_area
        @area = Area.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def area_params
        params.require(:area).permit(:name, :city_id, :radius, :stringified_coordinate, :active)
      end
  end
end
