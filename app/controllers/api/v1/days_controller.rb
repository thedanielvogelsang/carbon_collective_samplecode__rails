class Api::V1::DaysController < ApplicationController
  def index
    render json: Day.all.order(:date)
  end

  def show
    render json: Day.find(params[:id])
  end
end
