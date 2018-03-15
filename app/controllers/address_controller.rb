class AddressController < ApplicationController
  before_action :require_user

  def new
    @user = User.find(params['id'])
    @address = Address.new
  end

  def create
    byebug
    #redirect_to new_house_path({user_id: @user.id, address_id: @address.id})
  end

end
