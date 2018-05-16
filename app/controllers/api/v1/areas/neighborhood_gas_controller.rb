class Api::V1::Areas::NeighborhoodGasController < ApplicationController
  def index
    if params[:city]
      id = City.find_by(name: params[:city])
      render json: Neighborhood.where(city_id: id)
      .order(avg_daily_gas_consumed_per_user: :desc)
      .distinct, each_serializer: NeighborhoodGasSerializer
    else
      render json: Neighborhood.joins(:users).order(avg_daily_gas_consumed_per_user: :desc)
      .distinct, each_serializer: NeighborhoodGasSerializer
    end
  end

  def show
    if Neighborhood.exists?(params[:id])
      render json: Neighborhood.find(params[:id]), serializer: NeighborhoodGasSerializer
    else
      render json: {error: "neighborhood not in database. try again!"}, status: 404
    end
  end

  def users
    if Neighborhood.exists?(params[:id])
      render json: Neighborhood.find(params[:id]).users.order(total_gas_savings: :desc).limit(10)
    else
      render json: {error: "neighborhood not in database. try again!"}, status: 404
    end
  end
end
