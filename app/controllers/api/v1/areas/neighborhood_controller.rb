class Api::V1::Areas::NeighborhoodController < ApplicationController
  def index
    if params[:city]
      id = City.find_by(name: params[:city])
      render json: Neighborhood.where(city_id: id).joins(:users).order(total_energy_saved: :desc).distinct
    else
      render json: Neighborhood.joins(:users).order(total_energy_saved: :desc).distinct
    end
  end

  def show
    render json: Neighborhood.find(params[:id])
  end
  def users
    render json: Neighborhood.find(params[:id]).users.order(total_electricity_savings: :desc).limit(10)
  end
end
