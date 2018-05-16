class Api::V1::Areas::RegionController < ApplicationController
  def index
    if params[:country_id]
      render json: Country.find(params[:country_id]).regions.order(:name)
    else
      render json: Region.all.order(:name)
    end
  end
end
