class Api::V1::Areas::RegionCarbonController < ApplicationController
  def index
    if params[:country]
      country = Country.find_by(name: params[:country])
      render json: Region.where(country_id: country.id).joins(:users)
            .joins(:carbon_ranking)
            .merge(CarbonRanking.order(:avg_daily_carbon_consumed_per_user)).uniq,
        each_serializer: RegionCarbonSerializer
    else
      render json: Region.joins(:users)
            .joins(:carbon_ranking)
            .merge(CarbonRanking.order(:avg_daily_carbon_consumed_per_user)).uniq,
        each_serializer: RegionCarbonSerializer
    end
  end

  def show
    if Region.exists?(params[:id])
      render json: Region.find(params[:id]), serializer: RegionCarbonSerializer
    else
      render json: {error: "Region not in database. try again!"}, status: 404
    end
  end

  def update
    if Region.exists?(params[:id])
      region = Region.find(params[:id])
      n_ranking = region.carbon_ranking
      if n_ranking.update(safe_params)
        render json: region, serializer: RegionCarbonSerializer
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
