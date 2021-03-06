class Api::V1::Areas::CityController < ApplicationController
  def index
    if params[:region_id]
      render json: City.where(region_id: params[:region_id]).order(:name)
    else
      render json: City.all.order(:name)
    end
  end

  def show
    if City.exists?(params[:id])
      render json: City.find(params[:id]), serializer: CityElectricitySerializer
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end
end
