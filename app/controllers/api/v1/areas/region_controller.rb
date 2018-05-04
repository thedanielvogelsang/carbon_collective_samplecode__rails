class Api::V1::Areas::RegionController < ApplicationController

  def index
    if params[:country]
      id = Country.find_by(name: params[:country])
      render json: Region.where(country_id: id).joins(:users).order(total_energy_saved: :desc).distinct
    else
      render json: Region.order(avg_daily_energy_consumed_per_capita: :asc).distinct
    end
  end

  def show
    render json: Region.find(params[:id])
  end

  def users
    render json: Region.find(params[:id]).users.order(total_electricity_savings: :desc).limit(10)
  end
end
