class ElectricBillsController < ApplicationController


  private
    def safe_params
      params.require(:electric_bills).permit(:start_date, :end_date, :total_kwhs, :price, :house_id, :no_residents, :who)
    end
end
