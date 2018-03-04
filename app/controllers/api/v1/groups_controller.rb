class Api::V1::GroupsController < ApplicationController
  def index
    render json: Group.all.order(:id), each_serializer: GroupLongSerializer
  end

  def show
    render json: Group.find(params[:id])
  end
end
