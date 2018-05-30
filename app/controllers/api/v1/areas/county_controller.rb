class Api::V1::Areas::CountyController < ApplicationController

  def index
    if params[:region_id]
      render json: County.where(region_id: params[:region_id]).order(:name)
    else
      render json: County.all.order(:name)
    end
  end
end
