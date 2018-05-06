class Api::V1::Areas::RegionWaterController < ApplicationController

  def index
    if params[:country]
      id = Country.find_by(name: params[:country])
      render json: Region.where(country_id: id)
      .joins(:users).order(:total_water_saved)
      .distinct, each_serializer: RegionWaterSerializer
    else
      render json: Region
      .order(avg_daily_water_consumed_per_capita: :asc), each_serializer: RegionWaterSerializer
    end
  end

  def show
    if Region.exists?(params[:id])
      render json: Region.find(params[:id]), serializer: RegionWaterSerializer
    else
      render json: {error: "Region not in database. try again!"}, status: 404
    end
  end

  def users
    if Region.exists?(params[:id])
      render json: Region.find(params[:id])
      .users.order(total_water_savings: :desc)
      .limit(10)
    else
      render json: {error: "Region not in database. try again!"}, status: 404
    end
  end
end
