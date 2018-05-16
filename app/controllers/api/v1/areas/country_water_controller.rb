class Api::V1::Areas::CountryWaterController < ApplicationController

  # used for rankings
  def index
    render json: Country.order(avg_daily_water_consumed_per_user: :asc)
      .distinct, each_serializer: CountryWaterSerializer
  end

  #used for regional data page
  def show
    if Country.exists?(params[:id])
      render json: Country.find(params[:id]), serializer: CountryWaterSerializer
    else
      render json: {error: "Country not in database. try again!"}, status: 404
    end
  end

  # used for userboard for each regional area
  def users
    if Country.exists?(params[:id])
      render json: Country.find(params[:id])
          .users.order(total_water_savings: :desc)
          .limit(10), each_serializer: UserWaterSerializer
    else
      render json: {error: "Country not in database. try again!"}, status: 404
    end
  end
end
