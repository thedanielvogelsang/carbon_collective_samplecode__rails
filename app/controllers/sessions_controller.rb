class SessionsController < ApplicationController
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
      # have to complete this for non-fb logins
      user = User.find_by(email: params['post'][:email])
      user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user.id)
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to welcome_path
  end
end
