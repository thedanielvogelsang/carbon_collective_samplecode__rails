class Api::V1::Users::UsersElectricBillsController < ApplicationController

  def index
    if params[:user_id] && User.exists?(params[:user_id])
      user = User.find(params[:user_id])
      house = user.household
      render json: ElectricBill.joins(:house)
            .where(:houses => {id: house.id})
            .order(end_date: :desc), each_serializer: ElectricBillSerializer
    end
  end

  def update
    if params[:id] && User.exists(params[:user_id])
      bill = ElectricBill.find(params[:id])
      if bill.update(safe_params)
        render json: bill, status: 201
      else
        render json: {error: "Something went wrong"}, status: 404
      end
    end
  end

  private
    def safe_params
      params.require(:electric_bills).permit(:start_date, :end_date, :total_kwhs, :price, :house_id, :no_residents, :who)
    end
end
