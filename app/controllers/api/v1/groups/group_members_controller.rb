class Api::V1::Groups::GroupMembersController < ApplicationController
    def index
      render json: Group
            .find(params[:group_id])
            .users.uniq, each_serializer: FriendSerializer
    end
end
