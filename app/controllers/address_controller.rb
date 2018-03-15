class AddressController < ApplicationController
  before_action :require_user

  def new
    @user = User.find(params['id'])
    @address = Address.new
  end

  def create
    byebug
  end

end
