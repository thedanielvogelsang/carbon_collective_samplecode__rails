class Api::V1::AdminsController < ApplicationController

  def index
    render json: Admin.all.order(:id), each_serializer: AdminLongSerializer
  end

  def show
    render json: Group.joins(:admin).where(:admins => {id: params[:id]})
  end

end
