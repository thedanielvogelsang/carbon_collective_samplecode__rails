class Api::V1::Users::TripsController < ApplicationController
  def index
    render json: User.find(params[:user_id]).trips.order(created_at: :ASC)
  end

  def show
    render json: Trips.find(params[:id])
  end
end
