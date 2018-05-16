class Api::V1::Areas::CityElectricityController < ApplicationController

  # used for rankings, only neighborhoods with users listed
  def index
    if params[:region]
      id = Region.find_by(name: params[:region]).id
      render json: City.where(region_id: id).joins(:users)
        .order(avg_daily_electricity_consumed_per_user: :asc)
        .distinct, each_serializer: CityElectricitySerializer
    else
      render json: City
        .order(avg_daily_electricity_consumed_per_user: :asc), each_serializer: CityElectricitySerializer
    end
  end

  def show
    if City.exists?(params[:id])
      render json: City.find(params[:id]), serializer: CityElectricitySerializer
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end

  def users
    if City.exists?(params[:id])
      render json: City.find(params[:id])
        .users.order(total_electricity_savings: :desc)
        .limit(10), each_serializer: UserElectricitySerializer
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end
end
