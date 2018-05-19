class HeatBillsController < ApplicationController

  def create
    bill = HeatBill.new(safe_params)
    if bill.save
      render json: bill, status: 201
    else
      error = "Something went wrong, try again"
      render :json => {errors: error}, status: 401
    end
  end

  private
    def safe_params
      params.require(:gas_bills).permit(:start_date, :end_date, :total_therms, :price, :house_id)
    end
end
