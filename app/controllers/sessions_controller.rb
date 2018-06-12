class SessionsController < ApplicationController
  respond_to :json, :html

  def index
  end

  def new
    @user = User.new
  end

  def create
    # Not being used currently; facebook login
    if request.env['omniauth.auth']
      user = User.create_with_omniauth(request.env['omniauth.auth'])
      session[:user_id] = user.id
      redirect_to new_user_path({:user => {uid: user.uid}}) if user.addresses.empty?
      redirect_to user_path(user.id) if !user.addresses.empty?
    # regular app functions for new_user creation
    else
      user = User.find_by(email: safe_params[:email])
      respond_to do |format|
        if user && user.authenticate(safe_params[:password])
          if user.email_confirmed
            session[:user_id] = user.id
            format.json {render :json => user}
          else
            error = "Email Not Confirmed! Please confirm your email address to continue..."
            format.json {render :json => {:errors => error}, :status => 401 }
          end
        elsif user && !user.authenticate(safe_params[:password])
          error = 'Password/Email did not match. Please try again'
          format.json {render :json => {:errors => error}, :status => 401 }
        else
          error = 'Email not found. Please try again. If you havent made a CarbonCollective account yet, remember youll need an invite!'
          format.json {render :json => {:errors => error}, :status => 401 }
        end
      end
    end
  end

  private
    def safe_params
      params.require(:user).permit(:password, :email)
    end
end
