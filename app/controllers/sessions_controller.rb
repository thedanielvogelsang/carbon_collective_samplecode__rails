class SessionsController < ApplicationController
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
      user = User.find_by(email: params[:user][:email])
      respond_to do |format|
        if user && user.authenticate(params[:user][:password])
          session[:user_id] = user.id
          format.json {redirect_to user_path(user.id) }
          # redirect_to user_path(user.id)
        else
          flash[:error] = 'Password/Email did not match. Please try again'
          format.json {redirect_to welcome_path }
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
