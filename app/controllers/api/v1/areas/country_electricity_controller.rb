class Api::V1::Areas::CountryElectricityController < ApplicationController

  # used for rankings -- all countries listed
  def index
    render json: Country.order(avg_daily_electricity_consumed_per_user: :asc)
    .distinct, each_serializer: CountryElectricitySerializer
  end

  #used for regional data page
  def show
    if Country.exists?(params[:id])
      render json: Country.find(params[:id]), serializer: CountryElectricitySerializer
    else
      render json: {error: "Country not in database. try again!"}, status: 404
    end
  end

  # used for userboard for each regional area
  def users
    if Country.exists?(params[:id])
      render json: Country.find(params[:id])
          .users.order(total_electricity_savings: :desc)
          .limit(10), each_serializer: UserElectricitySerializer
    else
      render json: {error: "Country not in database. try again!"}, status: 404
    end
  end
  def update
    if Country.exists?(params[:id])
      country = Country.find(params[:id])
      c_ranking = country.electricity_ranking
      if c_ranking.update(safe_params)
        render json: country, serializer: CountryElectricitySerializer
      else
        render json: {error: "Country unable to update. Try again!"}, status: 404
      end
    else
      render json: {error: "Country not in database. Try again!"}, status: 404
    end
  end
  private

  def safe_params
    params.require("countries").permit(:rank, :arrow)
  end
end
