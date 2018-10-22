class Api::V1::Users::QuestionsController < ApplicationController

  def show
    user = User.friendly.find(params[:user_id])
    id = user.id
    hId = params[:house_id]
    if UserHouse.where(user_id: id, house_id: hId).empty?
      render json: {error: 'User and House do not match'}, status: 404
    elsif params[:resource]
      render json: UserElectricityQuestion.where(user_id: id, house_id: hId)[0] if params[:resource] == 'electricity'
      render json: UserWaterQuestion.where(user_id: id, house_id: hId)[0] if params[:resource] == 'water'
      render json: UserGasQuestion.where(user_id: id, house_id: hId)[0] if params[:resource] == 'gas'
    else
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
    end
  end

  def update
      user = User.friendly.find(params[:user_id])
      house = House.find(params[:house_id])
      r = params[:resource]
      uq = UserElectricityQuestion.where(user_id: user.id, house_id: house.id).first if r == 'electricity'
      uq = UserWaterQuestion.where(user_id: user.id, house_id: house.id).first if r == 'water'
      uq = UserGasQuestion.where(user_id: user.id, house_id: house.id).first if r == 'gas'
      if uq.update(safe_params)
        render json: uq, status: 201
      else
        render json: {error: "Something went wrong"}, status: 404
      end
  end

  private
    def safe_params
      params.require(:user_question).permit(:quest1, :quest2, :quest3, :quest4, :quest5, :quest_6)
    end
end
