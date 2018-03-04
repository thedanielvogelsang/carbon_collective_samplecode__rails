class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :member_count

  def member_count
    object.users.count
  end
end
