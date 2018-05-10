class Api::V1::Areas::CountryController < ApplicationController

  def index
    render json: Country.all.order(:name)
  end

end
