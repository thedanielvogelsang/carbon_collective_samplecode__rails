class Api::V1::UsersController < ApplicationController
  def index
    render json: User.all.order(:id)
  end

  def show
    if User.exists?(params[:id])
      render json: User.find(params[:id])
    else
      render json: {error: "User does not exist"}, status: 404
    end
  end

  def resources
    if User.exists?(params[:id])
      render json: User.find(params[:id]), serializer: UserElectricitySerializer if params[:resource] == 'electricity'
      render json: User.find(params[:id]), serializer: UserWaterSerializer if params[:resource] == 'water'
      # render json: User.find(params[:id]), serializer: UserGasSerializer if params[:resource] == 'gas'
    else
      render json: {error: "User does not exist"}, status: 404
    end
  end

  private
    def safe_params
      params.require(:user).permit(:email, :password)
    end
end
