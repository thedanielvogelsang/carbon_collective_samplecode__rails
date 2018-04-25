class Api::V1::HousesController < ApplicationController
  def index
    render json: House.all
  end

  def show
    render json: House.find(params[:id])
  end

  private
    def safe_params
      params.require(:house).permit(:total_sq_ft, :no_residents, :address_id)
    end
end
