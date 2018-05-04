class Api::V1::Areas::CountryController < ApplicationController
  def index
    render json: Country.order(avg_daily_energy_consumed_per_capita: :asc).distinct
  end
  def show
    render json: Country.find(params[:id])
  end
  def users
    render json: Country.find(params[:id]).users.order(total_electricity_savings: :desc).limit(10)
  end
end
