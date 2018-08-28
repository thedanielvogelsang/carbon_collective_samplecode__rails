class Api::V1::Users::UsersGasBillsController < ApplicationController

  def index
    if params[:user_id] && User.exists?(params[:user_id])
      user = User.find(params[:user_id])
      house = user.household
      uh = UserHouse.where(user_id: user.id, house_id: house.id)[0]
      render json: HeatBill.joins(:house)
                .where(:houses => {id: house.id})
                .order(end_date: :desc)
                .select{|b| b.start_date > uh.move_in_date}, each_serializer: HeatBillSerializer
    end
  end

  def create
    bill = HeatBill.new(safe_params)
    bill.user_id = User.find(params[:user_id]).id
    if bill.save
      render json: bill, status: 201
    else
      error = bill.errors.messages.first[1][0]
      render :json => {errors: error}, status: 401
    end
  end

  def update
    if params[:id] && User.exists(params[:user_id])
      bill = HeatBill.find(params[:id])
      if bill.update(safe_params)
        render json: bill, status: 201
      else
        render json: {error: "Something went wrong"}, status: 404
      end
    end
  end

  private
    def safe_params
      params.require(:gas_bills).permit(:start_date, :end_date, :total_therms, :price, :house_id, :no_residents, :who)
    end
end
