class AddressesController < ApplicationController
  before_action :require_user

  def new
    @user = User.find(params['id'])
    @address = Address.new
  end

  def create
    @user = User.find(params['address']['user_id'])
    @address = Address.create(safe_params)
    byebug
    if @address.save
      flash[:success] = "You are now a member of the CarbonCollective Community #{@user.first}"
      redirect_to user_path(@user.id)
    else
      flash[:error] = "Something went wrong"
      redirect_to new_address_path({id: @user.id})
    end
  end

  private
    def safe_params
      params.require(:address).permit(:geocoder_string)
    end

end
