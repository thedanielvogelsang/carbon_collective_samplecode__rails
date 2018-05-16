class Api::V1::Areas::CityGasController < ApplicationController

  def index
    if params[:region]
      id = Region.find_by(name: params[:region]).id
      render json: City.where(region_id: id).joins(:users)
        .order(avg_daily_gas_consumed_per_user: :asc)
        .distinct, each_serializer: CityGasSerializer
    else
      render json: City
        .order(avg_daily_gas_consumed_per_user: :asc), each_serializer: CityGasSerializer
    end
  end

  def show
    if City.exists?(params[:id])
      render json: City.find(params[:id]), serializer: CityGasSerializer
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end

  def users
    if City.exists?(params[:id])
      render json: City.find(params[:id])
        .users.order(total_gas_savings: :desc)
        .limit(10), each_serializer: UserGasSerializer
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end
end
