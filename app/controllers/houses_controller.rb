class HousesController < ApplicationController

  def create
    user = User.find(params[:user_id])
    @house = House.new(safe_params)
    if @house.save
      hId = @house.id
      user.houses << @house
      user.set_all_questions(hId)
      user.set_default_ranks
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
