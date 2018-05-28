class AddressesController < ApplicationController
  # before_action :require_user

  def create
    zipcode = Zipcode.find_or_create_by(zipcode: params[:zipcode]) if params[:zipcode]
    @address = Address.new(safe_params)
    @address.zipcode_id = zipcode.id
    if @address.save
      render json: @address, status: 202
    elsif !@address.save && @address.errors.messages[:address_line1][0] == 'has already been taken'
      city_id = @address.city_id
      address = @address.address_line1
      old_address = Address.where(address_line1: address, city_id: city_id)[0]
      @house = old_address.house
      error = "House already exists"
      render :json => {:errors => error, :house => @house.id}, status: 401
    else
      error = "Address did not save, please try again"
      render :json => {:errors => error}, status: 401
    end
  end

  def show
    if Address.exists?(params[:id])
      address = Address.find(params[:id])
      aline = address.address_line1 + ' ' +
        address.city.name + ', ' +
        address.city.region.name + ' -- ' +
        address.city.region.country.name
      render json: {address: address, address_line: aline}
    else
      error_message = "Couldn't find address"
      render json: {:error => error_message}, status: 404
    end
  end

  private
    def safe_params
      params.require(:address).permit(:address_line1, :address_line2, :city_id, :neighborhood_id)
    end
end
