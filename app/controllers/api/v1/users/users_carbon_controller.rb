class Api::V1::Users::UsersCarbonController < ApplicationController

  #updating userboard arrows and rankings
  def update
    if User.friendly.exists?(params[:user_id])
      user = User.friendly.find(params[:user_id])
      area = params[:region_type]
      a_id = params[:region_id]
      rank = UserCarbonRanking.find_by(user_id: user.id, area_type: area, area_id: a_id)
      if rank.update(safe_params)
        render json: user, serializer: UserCarbonSerializer
      else
        render json: {error: "Unable to update user ranking"}, status: 404
      end
    else
      render json: {:error => "Could not find user"}, status: 404
    end
  end

  private

    def safe_params
      params.require('user').permit(:rank, :arrow)
    end
end
