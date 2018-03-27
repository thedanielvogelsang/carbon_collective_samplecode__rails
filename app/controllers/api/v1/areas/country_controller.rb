class Api::V1::Areas::CountryController < ApplicationController
  def index
    render json: Country.all.order(:id)
  end
  def show
    render json: Country.find(params[:id])
  end
end
