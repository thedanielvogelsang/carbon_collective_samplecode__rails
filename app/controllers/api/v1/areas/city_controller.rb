class Api::V1::Areas::CityController < ApplicationController
  def index
    if params[:region]
      render json: Region.find(params[:region]).cities.order(:name)
    end
  end
end
