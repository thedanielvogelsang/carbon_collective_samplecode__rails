class Api::V1::Areas::CountryGasController < ApplicationController

  def index
    render json: Country.order(avg_daily_gas_consumed_per_user: :asc)
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
    id = params[:id]
    if Country.exists?(id)
      users = Country.find(id)
        .users.order(total_gas_savings: :desc)
          .limit(10)
      render json: users,  each_serializer: UserGasSerializer, region: {area_type: "Country", area_id: id}
    else
      render json: {error: "Country not in database. try again!"}, status: 404
    end
  end

  def update
    if Country.exists?(params[:id])
      country = Country.find(params[:id])
      c_ranking = country.gas_ranking
      if c_ranking.update(safe_params)
        render json: country, serializer: CountryGasSerializer
      else
        render json: {error: "Country unable to update. Try again!"}, status: 404
      end
    else
      render json: {error: "Country not in database. Try again!"}, status: 404
    end
  end
  private

  def safe_params
    params.require("countries").permit(:rank, :arrow)
  end
end
