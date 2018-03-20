class UsersController < ApplicationController
  before_action :require_user, only: [:show, :index, :update]

  def index
  end

  def show
    @global = GlobalHelper.total_to_date
    @user = User.find(params[:id])
    @user.total_co2_update
    @groups = @user.groups.limit(2)
  end

  def new
    params['user'] ? @user = User.find_by(uid: safe_params['uid']) : @user = User.new
  end

  def create
    @user = User.new(safe_params)
    if params[:password] == params[:password_confirmation] && @user.save
      flash[:success] = "User data success. Now lets log your home address to get you started"
      redirect_to new_address_path({id: @user.id})
    else
      flash[:error] = "Unsuccessful User Creation"
      redirect_to new_user_path
    end
  end

  def update
    user = User.find(params[:id])
    params['user']['password_confirmation'] != '' ? authenticate(user) : update_user(user)
  end

  private
    def authenticate(user)
      if user.authenticate(params[:user][:confirm_password])
        update_with_password(user)
      else
        flash[:error] = "Password confirmation incorrect"
        redirect_to settings_path
      end
    end

    def update_with_password(user)
      if user.update(safe_params)
        redirect_to user_path(user)
      else
        flash[:error] = "New password didnt match confirmation"
        redirect_to settings_path
      end
    end

    def update_user(user)
      if user.update(safe_params)
        redirect_to user_path(user.id) if !user.addresses.empty?
        redirect_to new_address_path({id: user.id}) if user.addresses.empty?
      else
        flash[:error] = "Unsuccessful update, please try again"
        redirect_back(fallback_location: user_path(user))
      end
    end

    def safe_params
      params.require('user').permit(:uid, :first, :last, :email, :password, :id, :password_confirmation)
    end
end
