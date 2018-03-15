class HousesController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @house = House.new
  end

  def create
    
  end
end
