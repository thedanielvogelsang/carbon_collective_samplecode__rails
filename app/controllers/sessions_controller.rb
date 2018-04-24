class SessionsController < ApplicationController
  protect_from_forgery with: :null_session

  respond_to :json, :html

  def index
  end

  def new
    @user = User.new
  end

  def create
    if request.env['omniauth.auth']
      user = User.create_with_omniauth(request.env['omniauth.auth'])
      session[:user_id] = user.id
      redirect_to new_user_path({:user => {uid: user.uid}}) if user.addresses.empty?
      redirect_to user_path(user.id) if !user.addresses.empty?
    else
      user = User.find_by(email: safe_params[:email])
      respond_to do |format|
        if user && user.authenticate(safe_params[:password])
          session[:user_id] = user.id
          format.json {render json: user}
        elsif user && !user.authenticate(safe_params[:password])
          flash[:error] = 'Password/Email did not match. Please try again'
          format.json {render :json => {:errors => flash[:error]}, :status => 401 }
        else
          flash[:error] = 'Email not found. Please try again'
          format.json {render :json => {:errors => flash[:error]}, :status => 401 }
        end
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to welcome_path
  end

  private
    def safe_params
      params.require(:user).permit(:password, :email)
    end
end
