class Api::V1::Areas::RegionController < ApplicationController
  def index
    render json: Region.all.order(:id)
  end
  def show
    render json: Region.find(params[:id])
  end
end
