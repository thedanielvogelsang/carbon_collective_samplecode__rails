class Api::V1::HousesController < ApplicationController
  def index
    render json: House.all
  end

  def show
    if House.exists?(params[:id])
      render json: House.find(params[:id])
    else
      render json: {error: "House does not exist"}, status: 404
    end
  end

  def users
    if House.exists?(params[:id])
      render json: House.find(params[:id]).users, each_serializer: UserSerializer
    else
      render json: {error: "House does not exist"}, status: 404
    end
  end

  def update
    if House.exists?(params[:id])
      house = House.find(params[:id])
      if house.update(safe_params)
        render json: house
      else
        error_message = "error! house could not update. try again"
        render json: {:error => error_message}, status: 404
      end
    else
      error_message = "House not found"
      render json: {:error => error_message}, status: 404
    end
  end

  def destroy
    if User.exists?(params[:user_id]) && House.exists?(params[:id])
      house = House.find(params[:id])
      userhouse = UserHouse.where(user_id: params[:user_id], house: house.id)[0]
      UserHouse.delete(userhouse.id)
      house.no_residents -= 1
      house.save
      if house.no_residents == 0
        House.destroy(house.id)
      end
      render json: userhouse
    else
      error_message = "Can't delete association"
      render json: {:error => error_message}, status: 404
    end
  end

  private
    def safe_params
      params.require(:house).permit(:total_sq_ft, :no_residents, :address_id)
    end
end
