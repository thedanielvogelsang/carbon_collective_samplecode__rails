class HousesController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @house = House.new
    @address = Address.find(params[:address_id])
  end

  def create
    user = User.find(params["house"]["user_id"])
    address = Address.find(params["house"]["address_id"])
    house = House.new(safe_params)
    house.address_id = address.id
    if user.save && house.save
      user.houses << house
      flash[:success] = "House added"
      redirect_to user_path(user)
    else
      flash[:error] = "House unsuccessfully added, try again"
      redirect_to new_house_path
    end
  end

  private
     def safe_params
        params.require(:house).permit(:total_sq_ft, :no_residents)
     end
end
