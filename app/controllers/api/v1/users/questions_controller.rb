class Api::V1::Users::QuestionsController < ApplicationController

  def show
    id = params[:user_id]
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
    if(!params[:user_question])
      user = User.find(params[:user_id])
      house = House.find(params[:house_id])
      r = params[:resource]
      uq = UserElectricityQuestion.where(user_id: user.id, house_id: house.id).first if r == 'electricity'
      uq = UserWaterQuestion.where(user_id: user.id, house_id: house.id).first if r == 'water'
      uq = UserGasQuestion.where(user_id: user.id, house_id: house.id).first if r == 'gas'
      if uq.update_with_params(params[:question], params[:answer])
        render json: uq, status: 201
      else
        render json: {error: "Something went wrong"}, status: 404
      end
    else
      user = User.find(params[:user_id])
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
  end

  private
    def safe_params
      params.require(:user_question).permit(:question, :answer, :completion_percentage)
    end
end
