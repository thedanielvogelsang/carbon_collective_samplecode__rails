class Api::V1::Areas::CityCarbonController < ApplicationController
  def index
    if params[:parent]
      region = Region.find_by(name: params[:parent])
      render json: City.where(region_id: region.id).joins(:carbon_ranking).merge(CarbonRanking.order(avg_daily_carbon_consumed_per_user: :desc)), each_serializer: CityCarbonSerializer
    else
      render json: City.all, each_serializer: CityCarbonSerializer
    end
  end

  def show
    if City.exists?(params[:id])
      render json: City.find(params[:id]), serializer: CityCarbonSerializer
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end

  def users
    if City.exists?(params[:id])
      render json: City.find(params[:id])
        .users.order(total_Carbon_savings: :desc)
        .limit(10), each_serializer: UserCarbonSerializer
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end

  def update
    if City.exists?(params[:id])
      city = City.find(params[:id])
      c_ranking = city.carbon_ranking
      if c_ranking.update(safe_params)
        render json: city, serializer: CityCarbonSerializer
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
