class Api::V1::Areas::NeighborhoodGasController < ApplicationController
  def index
    if params[:parent]
      id = City.find_by(name: params[:parent])
      render json: Neighborhood.where(city_id: id).joins(:users)
        .order(avg_daily_gas_consumed_per_user: :asc)
        .distinct, each_serializer: NeighborhoodGasSerializer
    else
      render json: Neighborhood.joins(:users)
        .order(avg_daily_gas_consumed_per_user: :asc)
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
      render json: Neighborhood.find(params[:id])
          .users.order(total_gas_savings: :desc)
          .limit(10), each_serializer: UserGasSerializer
    else
      render json: {error: "neighborhood not in database. try again!"}, status: 404
    end
  end

  def update
    if Neighborhood.exists?(params[:id])
      neighborhood = Neighborhood.find(params[:id])
      n_ranking = neighborhood.gas_ranking
      if n_ranking.update(safe_params)
        render json: neighborhood, serializer: NeighborhoodGasSerializer
      else
        render json: {error: "Neighborhood unable to update. Try again!"}, status: 404
      end
    else
      render json: {error: "Neighborhood not in database. Try again!"}, status: 404
    end
  end
  private

  def safe_params
    params.require("neighborhoods").permit(:rank, :arrow)
  end
end
