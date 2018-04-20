class CalendarController < ApplicationController
  def create
    event = {title: params[:title], location: params[:location], start: params[:start], end: params[:end]}
    render json: {status: 204, event: event}
  end

  def destroy
  end
end
