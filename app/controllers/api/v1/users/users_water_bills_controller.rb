class Api::V1::Users::UsersWaterBillsController < ApplicationController

  def index
    if params[:user_id] && User.friendly.exists?(params[:user_id])
      user = User.friendly.find(params[:user_id])
      house = user.household
      uh = UserHouse.where(user_id: user.id, house_id: house.id)[0]
      render json: WaterBill.joins(:house)
                    .where(:houses => {id: house.id})
                    .order(end_date: :desc)
                    .select{|b| b.start_date >= uh.move_in_date}, each_serializer: WaterBillSerializer
    end
  end

  def create
    bill = WaterBill.new(safe_params)
    bill.user_id = User.friendly.find(params[:user_id]).id
    if bill.save
      render json: bill, status: 201
    else
      error = bill.errors.messages.first[1][0]
      render :json => {errors: error}, status: 401
    end
  end

  def update
    if params[:id] && User.friendly.exists(params[:user_id])
      bill = WaterBill.find(params[:id])
      if WaterBill.updated?(bill, safe_params)
        who = User.friendly.find(params[:user_id])
        bill.who = who
        bill.save
        message = "Bill Saved"
        render json: {status: 202, error: message}
      else
        bill.update(safe_params)
        error = bill.errors.messages.first.join(' ')
        render json: {error: error}, status: 404
      end
    end
  end

  def destroy
    if User.friendly.exists?(params[:user_id]) && WaterBill.exists?(params[:id])
      WaterBill.destroy(params[:id])
      message = "Bill removed and data saved"
      render :json => {status: 202, error: message}
    else
      error = "Something went wrong"
      render :json => {status: 404, error: error}
    end
  end

  private
    def safe_params
      params.require(:water_bills).permit(:start_date, :end_date, :total_gallons, :price, :house_id, :no_residents, :who)
    end
end
