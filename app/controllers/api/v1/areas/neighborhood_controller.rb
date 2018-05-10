class Api::V1::Areas::NeighborhoodController < ApplicationController

  def index
    if params[:city]
      render json: Neighborhood.where(city_id: params[:city]).order(:name)
    else
      render json: Neighborhood.all.order(:id)
    end
  end

end
