class Api::V1::Areas::RegionElectricityController < ApplicationController

  def index
    # if clause used for search_address
    if params[:country]
      id = Country.find_by(name: params[:country]).id
      render json: Region.where(country_id: id)
      .order(avg_daily_electricity_consumed_per_user: :asc)
      .distinct, each_serializer: RegionElectricitySerializer
    else
      render json: Region
        .order(avg_daily_electricity_consumed_per_user: :asc),
        each_serializer: RegionElectricitySerializer
    end
  end

  def show
    if Region.exists?(params[:id])
      render json: Region.find(params[:id]), serializer: RegionElectricitySerializer
    else
      render json: {error: "Region not in database. try again!"}, status: 404
    end
  end

  def users
    if Region.exists?(params[:id])
      render json: Region.find(params[:id])
        .users.order(total_electricity_savings: :desc)
          .limit(10), each_serializer: UserElectricitySerializer
    else
      render json: {error: "Region not in database. try again!"}, status: 404
    end
  end
end
