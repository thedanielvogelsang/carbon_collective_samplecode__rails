class Api::V1::Areas::RegionWaterController < ApplicationController

  # used for rankings
  def index
    # renders only states WITH users
    if params[:parent] && Country.find_by(name: params[:parent])
      id = Country.find_by(name: params[:parent]).id
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
    id = params[:id]
    if Region.exists?(id)
      users = Region.find(id)
        .users.order(total_water_savings: :desc)
          .limit(10)
      render json: users,  each_serializer: UserWaterSerializer, region: {area_type: "Region", area_id: id}
    else
      render json: {error: "Region not in database. try again!"}, status: 404
    end
  end

  def update
    if Region.exists?(params[:id])
      region = Region.find(params[:id])
      n_ranking = region.water_ranking
      if n_ranking.update(safe_params)
        render json: region, serializer: RegionWaterSerializer
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
