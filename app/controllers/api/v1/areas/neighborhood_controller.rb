class Api::V1::Areas::NeighborhoodController < ApplicationController

  def index
    if params[:city_id]
      render json: Neighborhood.where(city_id: params[:city_id]).order(:name)
    else
      render json: Neighborhood.all.order(:name)
    end
  end

end
