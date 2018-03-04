class Api::V1::Users::GroupsController < ApplicationController
  def index
    render json: User.find(params[:user_id]).groups
  end

  def show
    rendering = Group.find(params[:id])
                .users.zip(User.find(params[:user_id]).friendships)
                .select{|x, y| x === y}
    if rendering
      render json: rendering[0].uniq
    else
      render json: Array.new
    end
  end
end
