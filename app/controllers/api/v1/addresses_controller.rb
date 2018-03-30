class Api::V1::AddressesController < ApplicationController

  def create
    zipcode = Zipcode.find_or_create_by(zipcode: params[:zipcode]) if params[:zipcode]
    @address = Address.new(safe_params)
    @address.zipcode_id = zipcode.id
    if @address.save
      render json: @address, status: 202
    else
      render file: 'public/404'
    end
  end

  def update
    zipcode = Zipcode.find_or_create_by(zipcode: params[:zipcode]) if params[:zipcode]
    @address = Address.find(params[:id])
    zipcode ? @address.zipcode_id = zipcode.id : nil
    if @address.update(safe_params)
      render json: @address, status: 202
    else
      render file: 'public/404'
    end
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    render json: address, status: 204 
  end

  private
    def safe_params
      params.require(:address).permit(:address_line1, :address_line2, :city, :neighborhood_name, :state, :country)
    end

end
