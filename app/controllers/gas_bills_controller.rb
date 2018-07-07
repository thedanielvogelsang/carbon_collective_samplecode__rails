class GasBillsController < ApplicationController



  private
    def safe_params
      params.require(:gas_bills).permit(:start_date, :end_date, :total_therms, :price, :house_id, :no_residents, :who)
    end
end
