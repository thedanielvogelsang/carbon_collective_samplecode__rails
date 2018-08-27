class Api::V1::Areas::CityCarbonController < ApplicationController
  def index
    if params[:parent]
      id = Region.find_by(name: params[:parent]).id
      render json: City.where(region_id: id).joins(:users)
        .order(avg_daily_carbon_consumed_per_user: :asc)
        .distinct, each_serializer: CityCarbonSerializer
    else
      render json: City
        .order(avg_daily_carbon_consumed_per_user: :asc), each_serializer: CityCarbonSerializer
    end
  end

  def show
    if City.exists?(params[:id])
      render json: City.find(params[:id]), serializer: CityCarbonSerializer
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end

  def users
    id = params[:id]
    if City.exists?(id)
      users = City.find(id)
        .users.order(total_carbon_savings: :desc)
          .limit(10)
      render json: users,  each_serializer: UserCarbonSerializer, region: {area_type: "City", area_id: id}
    else
      render json: {error: "City not in database. try again!"}, status: 404
    end
  end

  def update
    if City.exists?(params[:id])
      city = City.find(params[:id])
      c_ranking = city.carbon_ranking
      if c_ranking.update(safe_params)
        render json: city, serializer: CityCarbonSerializer
      else
        render json: {error: "City unable to update. Try again!"}, status: 404
      end
    else
      render json: {error: "City not in database. Try again!"}, status: 404
    end
  end

  private

  def safe_params
    params.require("cities").permit(:rank, :arrow)
  end
end
