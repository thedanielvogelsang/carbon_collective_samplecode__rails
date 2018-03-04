class FriendSerializer < ActiveModel::Serializer
  attributes :id, :username, :first, :last, :avatar_url

  def avatar_url
    object.url
  end
end
