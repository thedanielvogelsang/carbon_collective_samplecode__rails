class Api::V1::Areas::NeighborhoodController < ApplicationController
  def index
    render json: Neighborhood.all.order(:id)
  end
  def show
    render json: Neighborhood.find(params[:id])
  end
end
