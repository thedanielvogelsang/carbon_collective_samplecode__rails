class SessionsController < ApplicationController
  respond_to :json, :html
  
  def index
  end

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: safe_params[:email])
    if user && user.authenticate(safe_params[:password])
      if user.email_confirmed
        user.update_login
        user.calc_avg
        session[:user_id] = user.id
        render :json => user
      else
        error = "Email Not Confirmed! Please use the link sent to your email to continue..."
        render :json => {:errors => error}, :status => 401
      end
    elsif user && !user.authenticate(safe_params[:password])
      error = 'Password/Email did not match. Please try again. Remember both are case sensitive!'
      render :json => {:errors => error}, :status => 401
    else
      error = 'Email not found. Email/Password are case-sensitive. Please try again. If you havent made a CarbonCollective account yet, remember youll need an invite!'
      render :json => {:errors => error}, :status => 401
    end
  end

  private
    def safe_params
      params.require(:user).permit(:password, :email)
    end
end
