class Api::V1::Areas::CountyWaterController < ApplicationController

  # used for rankings
  def index
    render json: County.order(avg_daily_water_consumed_per_user: :asc).joins(:users)
      .distinct, each_serializer: CountyWaterSerializer
  end

  #used for regional data page
  def show
    if County.exists?(params[:id])
      render json: County.find(params[:id]), serializer: CountyWaterSerializer
    else
      render json: {error: "County not in database. try again!"}, status: 404
    end
  end

  # used for userboard for each regional area
  def users
    if County.exists?(params[:id])
      render json: County.find(params[:id])
          .users.order(total_water_savings: :desc)
          .limit(10), each_serializer: UserWaterSerializer
    else
      render json: {error: "County not in database. try again!"}, status: 404
    end
  end
  def update
    if County.exists?(params[:id])
      county = County.find(params[:id])
      c_ranking = county.water_ranking
      if c_ranking.update(safe_params)
        render json: county, serializer: CountyWaterSerializer
      else
        render json: {error: "County unable to update. Try again!"}, status: 404
      end
    else
      render json: {error: "County not in database. Try again!"}, status: 404
    end
  end
  private

  def safe_params
    params.require("countries").permit(:rank, :arrow)
  end
end
