class ElectricBillsController < ApplicationController

  def create
    bill = ElectricBill.new(safe_params)
    if bill.save
      render json: bill, status: 201
    else
      error = bill.errors.messages.first[1][0]
      render :json => {errors: error}, status: 401
    end
  end

  private
    def safe_params
      params.require(:electric_bills).permit(:start_date, :end_date, :total_kwhs, :price, :house_id)
    end
end
