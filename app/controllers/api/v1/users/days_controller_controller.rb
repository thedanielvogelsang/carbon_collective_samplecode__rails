class Api::V1::Users::DaysControllerController < ApplicationController

  def index
    render json: Day.joins(:trips).where(:trips => {user_id: params[:id]})
  end

end
