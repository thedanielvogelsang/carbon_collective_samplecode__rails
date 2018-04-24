class Api::V1::Areas::CityController < ApplicationController
  def index
    if params[:region]
      id = Region.find_by(name: params[:region])
      render json: City.where(region_id: id).joins(:users).order(total_energy_saved: :desc).distinct
    else
      render json: City.joins(:users).order(total_energy_saved: :desc).distinct
    end
  end
  def show
    render json: City.find(params[:id])
  end
end
