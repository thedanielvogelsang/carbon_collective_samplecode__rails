class ElectricBillsController < ApplicationController
  def new
    @user = User.find(params['user_id'])
    @electric_bill = ElectricBill.new
  end

  def create
    user = User.find(params["electric_bill"]["user_id"])
    bill = ElectricBill.new(safe_params)
    bill.user_id = user.id
    if bill.save && user.save
      flash[:success] = "Bill logged"
      redirect_to user_path(user.id)
    else
      flash[:error] = "Something went wrong, try again"
      redirect_to new_electric_bills_path(user_id: user.id)
    end
  end

  private
    def safe_params
      params.require(:electric_bill).permit(:start_date, :end_date, :total_kwhs, :price)
    end
end
