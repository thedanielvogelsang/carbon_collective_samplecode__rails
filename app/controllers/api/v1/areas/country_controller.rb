class Api::V1::Areas::CountryController < ApplicationController
  def index
    render json: Country.joins(:users).order(total_energy_saved: :desc).distinct
  end
  def show
    render json: Country.find(params[:id])
  end
end
