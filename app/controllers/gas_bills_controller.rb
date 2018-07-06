class GasBillsController < ApplicationController

  def create
    bill = HeatBill.new(safe_params)
    if bill.save
      render json: bill, status: 201
    else
      error = bill.errors.messages.first[1][0]
      render :json => {errors: error}, status: 401
    end
  end

  private
    def safe_params
      params.require(:gas_bills).permit(:start_date, :end_date, :total_therms, :price, :house_id, :no_residents, :who)
    end
end
