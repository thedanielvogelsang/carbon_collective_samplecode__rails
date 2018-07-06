class Api::V1::Users::UsersWaterBillsController < ApplicationController

  def index
    if params[:user_id] && User.exists?(params[:user_id])
      user = User.find(params[:user_id])
      house = user.household
      render json: WaterBill.joins(:house)
                    .where(:houses => {id: house.id})
                    .order(end_date: :desc), each_serializer: WaterBillSerializer
    end
  end

  def update
    if params[:id] && User.exists(params[:user_id])
      bill = WaterBill.find(params[:id])
      if bill.update(safe_params)
        render json: bill, status: 201
      else
        render json: {error: "Something went wrong"}, status: 404
      end
    end
  end

  private
    def safe_params
      params.require(:water_bills).permit(:start_date, :end_date, :total_gallons, :price, :house_id, :no_residents, :who)
    end
end
