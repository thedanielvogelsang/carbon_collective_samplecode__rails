class Api::V1::Areas::CityWaterController < ApplicationController

  def index
    if params[:region]
      id = Region.find_by(name: params[:region])
      render json: City.where(region_id: id)
      .joins(:users).order(total_water_saved: :desc)
      .distinct, each_serializer: CityWaterSerializer
    else
      render json: City.joins(:users)
      .order(total_water_saved: :desc)
      .distinct, each_serializer: CityWaterSerializer
    end
  end

  def show
    if City.exists?(params[:id])
      render json: City.find(params[:id]), serializer: CityWaterSerializer
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end

  def users
    if City.exists?(params[:id])
      render json: City.find(params[:id]).users
      .order(total_water_savings: :desc)
      .limit(10)
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end
end
