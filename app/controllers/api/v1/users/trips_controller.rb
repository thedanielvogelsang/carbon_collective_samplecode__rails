class Api::V1::Users::TripsController < ApplicationController
  def index
    render json: Trip.user_sort(params[:user_id]), each_serializer: TripSerializer
  end

  def show
    render json: Trip.find(params[:id])
  end
end
