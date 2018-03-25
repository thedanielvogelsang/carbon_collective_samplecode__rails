class Api::V1::UsersController < ApplicationController
  def index
    render json: User.all.order(:id)
  end

  def show
    render json: User.find(params[:id])
  end

  def create
    user = User.new(safe_params)
    if user.save
      render json: User.last
    else
      render :json => {:error => "Unsuccessful user creation"}.to_json, :status => 400
    end
  end

  private
    def safe_params
      params.require(:user).permit(:email, :password)
    end
end
