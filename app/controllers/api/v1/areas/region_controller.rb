class Api::V1::Areas::RegionController < ApplicationController
  def index
    if params[:country]
      id = Country.find_by(name: params[:country])
      render json: Region.where(country_id: id).joins(:users).order(total_energy_saved: :desc).distinct
    else
      render json: Region.joins(:users).order(total_energy_saved: :desc).distinct
    end
  end
  def show
    render json: Region.find(params[:id])
  end
end
