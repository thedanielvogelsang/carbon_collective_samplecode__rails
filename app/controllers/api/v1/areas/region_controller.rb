class Api::V1::Areas::RegionController < ApplicationController

  def index
    if params[:country_id]
      render json: Region.where(country_id: params[:country_id]).order(:name)
    else
      render json: Region.all.order(:name)
    end
  end

  def show
    if params[:id]
      render json: Region.find(params[:id]), serializer: RegionElectricitySerializer
    else
      render json: {:error => "Region does not exist"}, status: 404
    end
  end
end
