class ElectricBillsController < ApplicationController

  def create
    bill = ElectricBill.new(safe_params)
    byebug
    if bill.save
      render json: bill, status: 201
    else
      error = "Something went wrong, try again"
      render :json => {errors: error}, status: 401
    end
  end

  private
    def safe_params
      params.require(:electric_bill).permit(:start_date, :end_date, :total_kwhs, :price, :house_id)
    end
end
