class Api::V1::Users::AdminsController < ApplicationController
  def index
    render json: Group.joins(:admin).where(:admins => {user_id: params[:user_id]})
  end
end
