class UsersController < ApplicationController
  before_action :require_user, only: [:show, :index, :update]
  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    params['user'] ? @user = User.find_by(uid: safe_params['uid']) : @user = User.new
  end

  def create
    @user = User.create(safe_params)
    if params[:password] == params[:password_confirmation] && @user.save
      flash[:success] = "User data success. Now lets log your home address to get you started"
      redirect_to new_address_path({id: @user.id})
    else
      flash[:error] = "Unsuccessful User Creation"
      redirect_to new_user_path
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(safe_params)
      redirect_to user_path(@user.id) if !@user.addresses.empty?
      redirect_to new_address_path({id: @user.id}) if @user.addresses.empty?
    else
      flash[:error] = "Unsuccessful update, please try again"
      redirect_back(fallback_location: root_path)
    end
  end

  private

    def safe_params
      params.require('user').permit(:uid, :first, :last, :email, :password, :id)
    end
end
