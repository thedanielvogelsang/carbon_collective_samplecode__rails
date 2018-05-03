class UsersController < ApplicationController
  respond_to :json

  def index
  end

  def show
    respond_to do |format|
      @global = GlobalHelper.total_to_date
      @user = User.find(params[:id])
      @user.total_co2_update
      @groups = @user.groups.limit(2)
      format.html { render :show}
      format.json do
        render 'show.html.erb'
      end
    end
  end

  def new
    params['user'] ? @user = User.find_by(uid: safe_params['uid']) : @user = User.new
  end

  def create
    @user = User.new(safe_params)
    respond_to do |format|
      if params[:user][:password] == params[:user][:passwordConfirmation] && @user.save
        session[:user_id] = @user.id
        format.json {render json: @user}
      elsif params[:user][:password] != params[:user][:passwordConfirmation]
        error = 'Passwords did not match. Please try again'
        format.json {render :json => {:errors => error}, :status => 401 }
      elsif !@user.errors.messages[:email].empty? && @user.errors.messages[:email][0] != 'has already been taken'
        error = "Email format invalid. If problem continues contact CarbonCollective systems support"
        format.json {render :json => {:errors => error}, :status => 401 }
      else
        error = "Email already taken. Did you forget your password?"
        format.json {render :json => {:errors => error}, :status => 401 }
      end
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(safe_params)
      render json: user, status: 200
    else
      error = user.errors.message
      render json: error, status: 401
    end
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
      params.require('user').permit(:first, :last, :email, :password)
    end
end
