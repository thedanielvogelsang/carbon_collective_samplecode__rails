class Api::V1::HousesController < ApplicationController
  def index
    render json: House.all
  end

  def show
    id = params[:id]
    if House.exists?(id)
      render json: House.find(id), serializer: HouseElectricitySerializer, user: params[:user_id] if params[:resource] == 'electricity'
      render json: House.find(id), serializer: HouseWaterSerializer, user: params[:user_id]  if params[:resource] == 'water'
      render json: House.find(id), serializer: HouseGasSerializer, user: params[:user_id]  if params[:resource] == 'gas'
      render json: House.find(id), serializer: HouseCarbonSerializer, user: params[:user_id]  if params[:resource] == 'carbon'
      render json: House.find(id), serializer: HouseElectricitySerializer, user: params[:user_id]  if params[:resource] == nil
    else
      render json: {error: "House does not exist"}, status: 404
    end
  end

  def users
    id = params[:id]
    if House.exists?(id)
      render json: House.find(id).users.sort{|s| s.avg_daily_electricity_consumption}, each_serializer: UserElectricitySerializer, region: {area_type: "House", area_id: id} if params[:resource] == 'electricity'
      render json: House.find(id).users.sort{|s| s.avg_daily_water_consumption}, each_serializer: UserWaterSerializer, region: {area_type: "House", area_id: id} if params[:resource] == 'water'
      render json: House.find(id).users.sort{|s| s.avg_daily_gas_consumption}, each_serializer: UserGasSerializer, region: {area_type: "House", area_id: id} if params[:resource] == 'gas'
      render json: House.find(id).users.sort{|s| s.avg_daily_carbon_consumption}, each_serializer: UserCarbonSerializer, region: {area_type: "House", area_id: id} if params[:resource] == 'carbon'
      render json: House.find(id).users, each_serializer: UserSerializer if params[:resource] == nil
    else
      render json: {error: "House does not exist"}, status: 404
    end
  end

  def update
    id = params[:id]
    if House.exists?(id)
      house = House.find(id)
      user = User.friendly.find(params[:user_id])
      if params[:user_house] && !params[:user_house][:move_in_date].nil?
        uh = house.user_houses.where(:user_houses => {user_id: user.id}).first
        if uh.move_in_date.strftime("%Y-%m-%d") == params[:user_house][:move_in_date]
          error_message = "ignore nil date"
          render json: {:error => error_message}, status: 404
        else
          original_date = uh.move_in_date
          uh.update(move_in_date: params[:user_house][:move_in_date])
          # job for updating users data CalculateUserScoreJob.perform(user, original_date)
          house = uh.house
          render json: house, serializer: HouseElectricitySerializer, user: user.id
        end
      elsif house.update(safe_params)
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
    if User.friendly.exists?(params[:user_id]) && House.exists?(id)
      user = User.friendly.find(params[:user_id])
      house = House.find(id)
        userhouse = UserHouse.where(user_id: user.id, house: house.id)[0]
        UserHouse.destroy(userhouse.id)
        user.remove_old_ranks
        user.remove_all_questions(house.id)
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
