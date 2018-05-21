class Api::V1::Areas::NeighborhoodCarbonController < ApplicationController
  def index
    if params[:city]
      city = City.find_by(name: params[:city])
      render json: Neighborhood.where(city: city).joins(:users)
            .joins(:carbon_ranking)
            .merge(CarbonRanking.order(:avg_daily_carbon_consumed_per_user)).uniq,
        each_serializer: NeighborhoodCarbonSerializer
    else
      render json: Neighborhood.joins(:users)
            .joins(:carbon_ranking)
            .merge(CarbonRanking.order(:avg_daily_carbon_consumed_per_user)).uniq,
        each_serializer: NeighborhoodCarbonSerializer
    end
  end

  def show
    if Neighborhood.exists?(params[:id])
      render json: Neighborhood.find(params[:id]), serializer: NeighborhoodCarbonSerializer
    else
      render json: {error: "Neighborhood not in database. try again!"}, status: 404
    end
  end

  def users
    if Neighborhood.exists?(params[:id])
      render json: Neighborhood.find(params[:id])
        .users.order(total_carbon_savings: :desc)
        .limit(10), each_serializer: UserCarbonSerializer
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
