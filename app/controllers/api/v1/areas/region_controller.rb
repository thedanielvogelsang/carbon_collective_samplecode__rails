class Api::V1::Areas::RegionController < ApplicationController
  def index
    if params[:country]
      render json: Country.find(params[:country]).regions.order(:name)
    else
      render json: Region.all.order(:name)
    end
  end
end
