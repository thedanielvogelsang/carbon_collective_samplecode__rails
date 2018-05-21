class Api::V1::Areas::CityGasController < ApplicationController

  def index
    if params[:parent]
      id = Region.find_by(name: params[:parent]).id
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

  def update
    if City.exists?(params[:id])
      city = City.find(params[:id])
      c_ranking = city.gas_ranking
      if c_ranking.update(safe_params)
        render json: city, serializer: CityGasSerializer
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
