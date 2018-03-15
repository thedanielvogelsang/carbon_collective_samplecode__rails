class UsersController < ApplicationController
  before_action :require_user, only: [:show, :index]
  def index
  end

  def show
    byebug
  end

  def new
    @user = User.new(safe_params)
    flash[:error] = "All fields must be filled in."
  end

  def create
  end

  private

    def safe_params
      params.require(:users).permit(:uid, :first, :last, :email, :address)
    end
end
