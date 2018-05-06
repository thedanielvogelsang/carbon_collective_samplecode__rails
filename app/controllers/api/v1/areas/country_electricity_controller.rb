class Api::V1::Areas::CountryElectricityController < ApplicationController

  def index
    render json: Country.order(avg_daily_electricity_consumed_per_capita: :desc).distinct
  end

  def show
    if Country.exists?(params[:id])
      render json: Country.find(params[:id])
    else
      render json: {error: "Country not in database. try again!"}, status: 404
    end
  end

  def users
    if Country.exists?(params[:id])
      render json: Country.find(params[:id]).users.order(total_electricity_savings: :desc).limit(10)
    else
      render json: {error: "Country not in database. try again!"}, status: 404
    end
  end
end
