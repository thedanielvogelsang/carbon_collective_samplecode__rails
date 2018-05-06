class Api::V1::Areas::CountryGasController < ApplicationController

  def index
    render json: Country.order(avg_daily_gas_consumed_per_capita: :desc)
    .distinct, each_serializer: CountryGasSerializer
  end

  def show
    if Country.exists?(params[:id])
      render json: Country.find(params[:id]), serializer: CountryGasSerializer
    else
      render json: {error: "Country not in database. try again!"}, status: 404
    end
  end

  def users
    if Country.exists?(params[:id])
      render json: Country.find(params[:id]).users.order(total_gas_savings: :desc).limit(10)
    else
      render json: {error: "Country not in database. try again!"}, status: 404
    end
  end
end
