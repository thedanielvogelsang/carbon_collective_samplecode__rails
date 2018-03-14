class UsersController < ApplicationController
  def index
  end

  def show
  end

  def new
    byebug
    if params[:uid]
      user = User.where(uid: params[:uid])
    else
      user = User.new(safe_params)
    end
  end

  def create
  end

  private

    def safe_params
      params.require(:user).permit(:first, :last, :email, :zipcode)
    end
end
