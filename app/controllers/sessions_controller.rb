class SessionsController < ApplicationController
  def index
  end

  def create
    if request.env['omniauth.auth']
      user = User.create_with_omniauth(request.env['omniauth.auth'])
      session[:user_id] = user.id
      redirect_to new_user_path({:users => {uid: user.uid}}) if user.addresses.empty?
      redirect_to user_path(user.id) if !user.addresses.empty?
    else
      # have to complete this for non-fb logins
      byebug
      user = User.where(email: params[:email])
      user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user.id)
    end
  end
end
