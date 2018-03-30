class Api::V1::HousesController < ApplicationController
  def index
    user = User.find(params[:user_id])
    render json: user.houses
  end

  def show
    render json: House.find(params[:id])
  end

  def create
    user = User.find(params[:user_id])
    @house = House.new(safe_params)
    if @house.save
      user.houses << @house
      render json: @house, status: 202
    else
      render file: "public/404"
    end
  end

  def update
    house = House.find(params[:id])
    house.update(safe_params)
    if house.save
      render json: house, status: 202
    else
      render file: "public/404"
    end
  end

  def destroy
  end

  private
    def safe_params
      params.require(:house).permit(:total_sq_ft, :no_residents, :address_id)
    end
end
