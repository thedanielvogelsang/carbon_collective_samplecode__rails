class Api::V1::Users::UsersWaterBillsController < ApplicationController

  def index
    if params[:user_id] && User.exists?(params[:user_id])
      user = User.find(params[:user_id])
      house = user.household
      render json: WaterBill.joins(:house)
                    .where(:houses => {id: house.id})
                    .order(created_at: :desc), each_serializer: WaterBillSerializer
    end
  end
end
