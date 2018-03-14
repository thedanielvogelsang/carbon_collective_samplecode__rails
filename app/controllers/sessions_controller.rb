class SessionsController < ApplicationController
  def index
  end

  def create
  if request.env['omniauth.auth']
    user = User.create_with_omniauth(request.env['omniauth.auth'])
    redirect_to new_user_path(user.uid)
  else
    byebug
    user = User.find_by_email(params[:email])
    user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect_to user_path(user.id)
  end
end
end
