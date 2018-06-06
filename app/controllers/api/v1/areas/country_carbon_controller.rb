class Api::V1::Areas::CountryCarbonController < ApplicationController

  def index
      render json: Country.joins(:carbon_ranking)
            .merge(CarbonRanking.order(:avg_daily_carbon_consumed_per_user)).uniq,
         each_serializer: CountryCarbonSerializer
  end

  def show
    if Country.exists?(params[:id])
      render json: Country.find(params[:id]), serializer: CountryCarbonSerializer
    else
      render json: {error: "Country not in database. try again!"}, status: 404
    end
  end

  # used for userboard for each regional area
  def users
    id = params[:id]
    if Country.exists?(id)
      users = Country.find(id)
        .users.order(total_carbon_savings: :desc)
          .limit(10)
      render json: users,  each_serializer: UserCarbonSerializer, region: {area_type: "Country", area_id: id}
    else
      render json: {error: "Country not in database. try again!"}, status: 404
    end
  end

  def update
    if Country.exists?(params[:id])
      country = Country.find(params[:id])
      c_ranking = country.carbon_ranking
      if c_ranking.update(safe_params)
        render json: country, serializer: CountryCarbonSerializer
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
