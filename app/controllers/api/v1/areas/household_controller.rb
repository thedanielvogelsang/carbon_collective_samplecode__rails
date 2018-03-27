class Api::V1::Areas::HouseholdController < ApplicationController
  def index
    render json: House.all.order(:id)
  end
  def show
    render json: House.find(params[:id])
  end
end
