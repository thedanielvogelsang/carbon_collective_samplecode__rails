class Api::V1::Areas::CityElectricityController < ApplicationController

  # used for rankings, only neighborhoods with users listed
  def index
    if params[:parent]
      id = Region.find_by(name: params[:parent]).id
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
      users = City.find(params[:id] )
        .users.order(total_electricity_savings: :desc)
        .limit(10)
      render json: users, each_serializer: UserElectricitySerializer
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end

  def update
    if City.exists?(params[:id])
      city = City.find(params[:id])
      c_ranking = city.electricity_ranking
      if c_ranking.update(safe_params)
        render json: city, serializer: CityElectricitySerializer
      else
        render json: {error: "City unable to update. Try again!"}, status: 404
      end
    else
      render json: {error: "City not in database. Try again!"}, status: 404
    end
  end

  private

  def safe_params
    params.require("cities").permit(:rank, :arrow)
  end
end
