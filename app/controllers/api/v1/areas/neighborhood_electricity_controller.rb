class Api::V1::Areas::NeighborhoodElectricityController < ApplicationController

  # used for rankings, only neighborhoods with users listed
  def index
    if params[:city]
      id = City.find_by(name: params[:city])
      render json: Neighborhood.where(city: id).joins(:users)
        .order(avg_daily_electricity_consumed_per_user: :asc)
        .distinct, each_serializer: NeighborhoodElectricitySerializer
    else
      render json: Neighborhood.joins(:users)
        .order(avg_daily_electricity_consumed_per_user: :asc)
        .distinct, each_serializer: NeighborhoodElectricitySerializer
    end
  end

  def show
    if Neighborhood.exists?(params[:id])
      render json: Neighborhood.find(params[:id]), serializer: NeighborhoodElectricitySerializer
    else
      render json: {error: "neighborhood not in database. try again!"}, status: 404
    end
  end

  def users
    if Neighborhood.exists?(params[:id])
      render json: Neighborhood.find(params[:id])
        .users.order(total_electricity_savings: :desc)
        .limit(10), each_serializer: UserElectricitySerializer
    else
      render json: {error: "neighborhood not in database. try again!"}, status: 404
    end
  end
end
