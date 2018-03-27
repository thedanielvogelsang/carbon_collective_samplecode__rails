class Api::V1::Areas::CityController < ApplicationController
  def index
    render json: City.all.order(:id)
  end
  def show
    render json: City.find(params[:id])
  end
end
