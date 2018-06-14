class Api::V1::HousesController < ApplicationController
  def index
    render json: House.all
  end

  def show
    id = params[:id]
    if House.exists?(id)
      render json: House.find(id), serializer: HouseElectricitySerializer if params[:resource] == 'electricity'
      render json: House.find(id), serializer: HouseWaterSerializer if params[:resource] == 'water'
      render json: House.find(id), serializer: HouseGasSerializer if params[:resource] == 'gas'
      render json: House.find(id), serializer: HouseCarbonSerializer if params[:resource] == 'carbon'
      render json: House.find(id), serializer: HouseElectricitySerializer if params[:resource] == nil
    else
      render json: {error: "House does not exist"}, status: 404
    end
  end

  def users
    id = params[:id]
    if House.exists?(id)
      render json: House.find(id).users, each_serializer: UserElectricitySerializer, region: {area_type: "House", area_id: id} if params[:resource] == 'electricity'
      render json: House.find(id).users, each_serializer: UserWaterSerializer, region: {area_type: "House", area_id: id} if params[:resource] == 'water'
      render json: House.find(id).users, each_serializer: UserGasSerializer, region: {area_type: "House", area_id: id} if params[:resource] == 'gas'
      render json: House.find(id).users, each_serializer: UserCarbonSerializer, region: {area_type: "House", area_id: id} if params[:resource] == 'carbon'
      render json: House.find(id).users, each_serializer: UserSerializer if params[:resource] == nil
    else
      render json: {error: "House does not exist"}, status: 404
    end
  end

  def update
    id = params[:id]
    if House.exists?(id)
      house = House.find(id)
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
    id = params[:id]
    if User.exists?(params[:user_id]) && House.exists?(id)
      house = House.find(id)
      userhouse = UserHouse.where(user_id: params[:user_id], house: house.id)[0]
      UserHouse.destroy(userhouse.id)
      ue = UserElectricityQuestion.where(user_id: user.id, house_id: hId)[0]
      uw = UserWaterQuestion.where(user_id: user.id, house_id: hId)[0]
      ug = UserGasQuestion.where(user_id: user.id, house_id: hId)[0]
      UserElectricityQuestion.destroy(ue.id)
      UserWaterQuestion.destroy(uw.id)
      UserGasQuestion.destroy(ug.id)
      if house.users.count == 0
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
      params.require(:house).permit(:total_sq_ft, :no_residents, :address_id, :apartment)
    end
end
