class Api::V1::HousesController < ApplicationController
  def index
    render json: House.all
  end

  def show
    if House.exists?(params[:id])
      render json: House.find(params[:id])
    else
      render json: {error: "House does not exist"}, status: 404
    end
  end

  private
    def safe_params
      params.require(:house).permit(:total_sq_ft, :no_residents, :address_id)
    end
end
