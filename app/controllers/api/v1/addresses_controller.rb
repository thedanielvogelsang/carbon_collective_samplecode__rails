class Api::V1::AddressesController < ApplicationController

  def index
    render json: Address.all
  end

  def show
    render json: Address.find(params[:id])
  end

  private
    def safe_params
      params.require(:address).permit(:address_line1, :address_line2, :city, :neighborhood_name, :state, :country)
    end

end
