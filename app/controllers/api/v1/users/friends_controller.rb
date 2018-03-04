class Api::V1::Users::FriendsController < ApplicationController
  def index
    render json: User.find(params[:user_id]).friendships, each_serializer: FriendSerializer
  end

  def show
    render json: User.find(params[:id])
  end

  def create
  end

  def edit
  end

  def destroy
  end
end
