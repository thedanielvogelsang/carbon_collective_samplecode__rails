class HousesController < ApplicationController

  def create
    user = User.friendly.find(params[:user_id])
    @house = House.new(safe_params)
    if @house.save
      hId = @house.id
      UserHouse.create(user_id: user.id,
                      house_id: hId,
                      move_in_date: DateTime.new(params[:moveInDate])
                            .in_time_zone("Mountain Time (US & Canada)")
                      )
      render json: @house, status: 202
    else
      error = "house did not save, please try again"
      render :json => {errors: error}, status: 401
    end
  end

  private
     def safe_params
        params.require(:house).permit(:total_sq_ft, :no_residents, :address_id, :apartment)
     end
end
