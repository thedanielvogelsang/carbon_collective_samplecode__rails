class Api::V1::Areas::NeighborhoodController < ApplicationController

  def index
    if params[:city]
      render json: Neighborhood.where(city_id: params[:city]).order(:name)
    end
  end

end
