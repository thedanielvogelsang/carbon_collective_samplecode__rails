class Api::V1::Areas::RegionCarbonController < ApplicationController
  def index
    if params[:parent] && Country.find_by(name: params[:parent])
      id = Country.find_by(name: params[:parent]).id
      render json: Region.where(country_id: id)
      .order(avg_daily_carbon_consumed_per_user: :asc)
      .distinct, each_serializer: RegionCarbonSerializer
    else
      render json: Region
        .order(avg_daily_carbon_consumed_per_user: :asc),
        each_serializer: RegionCarbonSerializer
    end
  end

  def show
    if Region.exists?(params[:id])
      render json: Region.find(params[:id]), serializer: RegionCarbonSerializer
    else
      render json: {error: "Region not in database. try again!"}, status: 404
    end
  end

  def users
    id = params[:id]
    if Region.exists?(id)
      users = Region.find(id)
        .users.order(total_carbon_savings: :desc)
          .limit(10)
      render json: users,  each_serializer: UserCarbonSerializer, region: {area_type: "Region", area_id: id}
    else
      render json: {error: "Region not in database. try again!"}, status: 404
    end
  end

  def update
    if Region.exists?(params[:id])
      region = Region.find(params[:id])
      r_ranking = region.carbon_ranking
      if r_ranking.update(safe_params)
        render json: region, serializer: RegionCarbonSerializer
      else
        render json: {error: "Region unable to update. Try again!"}, status: 404
      end
    else
      render json: {error: "Region not in database. Try again!"}, status: 404
    end
  end
  private

    def safe_params
      params.require("regions").permit(:rank, :arrow)
    end
end
