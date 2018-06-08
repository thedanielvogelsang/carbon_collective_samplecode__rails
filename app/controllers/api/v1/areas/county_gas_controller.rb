class Api::V1::Areas::CountyGasController < ApplicationController

  def index
    render json: County.order(avg_daily_gas_consumed_per_user: :asc).joins(:users)
    .distinct, each_serializer: CountyGasSerializer
  end

  def show
    if County.exists?(params[:id])
      render json: County.find(params[:id]), serializer: CountyGasSerializer
    else
      render json: {error: "County not in database. try again!"}, status: 404
    end
  end

  def users
    if County.exists?(params[:id])
      users = County.find(params[:id])
        .users.order(total_gas_savings: :desc)
        .limit(10)
      render json: users, each_serializer: UserGasSerializer, region: {area_type: "County", area_id: params[:id]}
    else
      render json: {error: "County not in database. try again!"}, status: 404
    end
  end

  def update
    if County.exists?(params[:id])
      county = County.find(params[:id])
      c_ranking = county.gas_ranking
      if c_ranking.update(safe_params)
        render json: county, serializer: CountyGasSerializer
      else
        render json: {error: "County unable to update. Try again!"}, status: 404
      end
    else
      render json: {error: "County not in database. Try again!"}, status: 404
    end
  end
  private

  def safe_params
    params.require("counties").permit(:rank, :arrow)
  end
end
