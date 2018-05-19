class WaterBillsController < ApplicationController

  def create
    bill = WaterBill.new(safe_params)
    if bill.save
      render json: bill, status: 201
    else
      error = bill.errors.messages
      render :json => {errors: error}, status: 401
    end
  end

  private
    def safe_params
      params.require(:water_bills).permit(:start_date, :end_date, :total_gallons, :price, :house_id)
    end
end
