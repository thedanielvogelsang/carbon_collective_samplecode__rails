class Api::V1::Areas::RegionWaterController < ApplicationController

  # used for rankings
  def index
    # renders only states WITH users
    if params[:country]
      id = Country.find_by(name: params[:country]).id
      render json: Region.where(country_id: id)
        .order(avg_daily_water_consumed_per_user: :asc)
        .distinct, each_serializer: RegionWaterSerializer
    #renders all regions, regardless of country or users
    else
      render json: Region
        .order(avg_daily_water_consumed_per_capita: :asc),
        each_serializer: RegionWaterSerializer
    end
  end

  #used for regional data page
  def show
    if Region.exists?(params[:id])
      render json: Region.find(params[:id]), serializer: RegionWaterSerializer
    else
      render json: {error: "Region not in database. try again!"}, status: 404
    end
  end

  # used for userboard for each regional area
  def users
    if Region.exists?(params[:id])
      render json: Region.find(params[:id])
        .users.order(total_water_savings: :desc)
          .limit(10), each_serializer: UserWaterSerializer
    else
      render json: {error: "Region not in database. try again!"}, status: 404
    end
  end
end
