class Api::V1::Areas::NeighborhoodCarbonController < ApplicationController
  def index
    if params[:parent]
      id = City.find_by(name: params[:parent])
      render json: Neighborhood.where(city: id).joins(:users)
        .order(avg_daily_carbon_consumed_per_user: :asc)
        .distinct, each_serializer: NeighborhoodCarbonSerializer
    else
      render json: Neighborhood.joins(:users)
        .order(avg_daily_carbon_consumed_per_user: :asc)
        .distinct, each_serializer: NeighborhoodCarbonSerializer
    end
  end

  def show
    id = params[:id]
    if Neighborhood.exists?(id)
      render json: Neighborhood.find(id), serializer: NeighborhoodCarbonSerializer
    else
      render json: {error: "Neighborhood not in database. try again!"}, status: 404
    end
  end

  def users
    id = params[:id]
    byebug
    if Neighborhood.exists?(id)
      users = Neighborhood.find(id)
        .users.order(total_carbon_savings: :desc)
        .limit(10)
      render json: users, each_serializer: UserCarbonSerializer, region: {area_type: "Neighborhood", area_id: id}
    else
      render json: {error: "neighborhood not in database. try again!"}, status: 404
    end
  end

  def update
    if Neighborhood.exists?(params[:id])
      neighborhood = Neighborhood.find(params[:id])
      n_ranking = neighborhood.carbon_ranking
      if n_ranking.update(safe_params)
        render json: neighborhood, serializer: NeighborhoodCarbonSerializer
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
