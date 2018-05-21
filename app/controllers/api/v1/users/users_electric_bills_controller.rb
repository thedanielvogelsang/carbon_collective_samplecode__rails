class Api::V1::Users::UsersElectricBillsController < ApplicationController

  def index
    if params[:user_id] && User.exists?(params[:user_id])
      user = User.find(params[:user_id])
      house = user.household
      render json: ElectricBill.joins(:house)
            .where(:houses => {id: house.id})
            .order(created_at: :desc), each_serializer: ElectricBillSerializer
    end
  end
end
