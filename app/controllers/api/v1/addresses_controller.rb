class Api::V1::AddressesController < ApplicationController

  def index
    render json: Address.all
  end

  def show
    if Address.exists?(params[:id])
      render json: Address.find(params[:id])
    else
      render json: {error: "Address does not exist"}, status: 404
    end
  end

  private
    def safe_params
      params.require(:address).permit(:address_line1, :address_line2, :city, :neighborhood_name, :state, :country)
    end

end
