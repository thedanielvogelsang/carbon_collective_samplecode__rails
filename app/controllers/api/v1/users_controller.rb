class Api::V1::UsersController < ApplicationController
  skip_before_action :look_for_token
  # development;
  def index
    render json: User.friendly.all.order(:id)
  end

  #handy for development and used for user_settings, etc.
  def show
    if User.friendly.exists?(params[:id])
      render json: User.friendly.find(params[:id])
    else
      render json: {error: "User does not exist"}, status: 404
    end
  end

  #used for dashboard get fetch
  def resources
    if User.friendly.exists?(params[:id])
      render json: User.friendly.find(params[:id]), serializer: UserElectricitySerializer if params[:resource] == 'electricity'
      render json: User.friendly.find(params[:id]), serializer: UserWaterSerializer if params[:resource] == 'water'
      render json: User.friendly.find(params[:id]), serializer: UserGasSerializer if params[:resource] == 'gas'
      render json: User.friendly.find(params[:id]), serializer: UserCarbonSerializer if params[:resource] == 'carbon'
    else
      render json: {error: "User does not exist"}, status: 404
    end
  end

  private
    def safe_params
      params.require(:user).permit(:email, :password, :rank, :arrow)
    end
end
