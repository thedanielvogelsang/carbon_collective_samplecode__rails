class ApplicationController < ActionController::Base
  protect_from_forgery
  skip_before_action :verify_authenticity_token

  respond_to :json

  helper_method :current_user
  helper_method :require_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    unless current_user
      flash[:error] = 'You must be logged in to access this page.'
      redirect_to login_path
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
