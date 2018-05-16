class Api::V1::Areas::NeighborhoodWaterController < ApplicationController
  def index
    if params[:city]
      id = City.find_by(name: params[:city])
      render json: Neighborhood.where(city_id: id).joins(:users)
        .order(avg_daily_water_consumed_per_user: :asc)
        .distinct, each_serializer: NeighborhoodWaterSerializer
    else
      render json: Neighborhood.joins(:users)
        .order(avg_daily_water_consumed_per_user: :asc)
        .distinct, each_serializer: NeighborhoodWaterSerializer
    end
  end

  def show
    if Neighborhood.exists?(params[:id])
      render json: Neighborhood.find(params[:id]), serializer: NeighborhoodWaterSerializer
    else
      render json: {error: "neighborhood not in database. try again!"}, status: 404
    end
  end

  def users
    if Neighborhood.exists?(params[:id])
      render json: Neighborhood.find(params[:id])
        .users.order(total_water_savings: :desc)
        .limit(10), each_serializer: UserWaterSerializer
    else
      render json: {error: "neighborhood not in database. try again!"}, status: 404
    end
  end
end
