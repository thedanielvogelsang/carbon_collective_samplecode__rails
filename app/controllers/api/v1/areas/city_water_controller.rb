class Api::V1::Areas::CityWaterController < ApplicationController

  def index
    if params[:parent] && Region.find_by(name: params[:parent])
      id = Region.find_by(name: params[:parent]).id
      render json: City.where(region_id: id).joins(:users)
        .order(avg_daily_water_consumed_per_user: :asc)
        .distinct, each_serializer: CityWaterSerializer
    else
      render json: City
        .order(avg_daily_water_consumed_per_user: :asc), each_serializer: CityWaterSerializer
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
    id = params[:id]
    if City.exists?(id)
      users = City.find(id)
        .users.order(total_water_savings: :desc)
          .limit(10)
      render json: users,  each_serializer: UserWaterSerializer, region: {area_type: "City", area_id: id}
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end

  def update
    if City.exists?(params[:id])
      city = City.find(params[:id])
      c_ranking = city.water_ranking
      if c_ranking.update(safe_params)
        render json: city, serializer: CityWaterSerializer
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
