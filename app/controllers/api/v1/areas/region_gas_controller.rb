class Api::V1::Areas::RegionGasController < ApplicationController

  def index
    if params[:country]
      id = Country.find_by(name: params[:country])
      render json: Region.where(country_id: id)
      .order(avg_daily_gas_consumed_per_user: :asc)
      .distinct, each_serializer: RegionGasSerializer
    else
      render json: Region
        .order(avg_daily_gas_consumed_per_capita: :asc),
        each_serializer: RegionGasSerializer
    end
  end

  def show
    if Region.exists?(params[:id])
      render json: Region.find(params[:id]), serializer: RegionGasSerializer
    else
      render json: {error: "Region not in database. try again!"}, status: 404
    end
  end

  def users
    if Region.exists?(params[:id])
      render json: Region.find(params[:id])
        .users.order(total_gas_savings: :desc)
          .limit(10), each_serializer: UserGasSerializer
    else
      render json: {error: "Region not in database. try again!"}, status: 404
    end
  end

  def update
    if Region.exists?(params[:id])
      region = Region.find(params[:id])
      n_ranking = region.gas_ranking
      if n_ranking.update(safe_params)
        render json: region, serializer: RegionGasSerializer
      else
        render json: {error: "Region unable to update. Try again!"}, status: 404
      end
    else
      render json: {error: "Region not in database. Try again!"}, status: 404
    end
  end
  private

  def safe_params
    params.require("regions").permit(:rank, :arrow)
  end
end
