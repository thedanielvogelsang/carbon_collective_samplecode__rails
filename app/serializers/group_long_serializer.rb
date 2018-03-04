class GroupLongSerializer < ActiveModel::Serializer
  attributes :id, :group_name, :member_count, :description, :admin_id

  def member_count
    object.users.count
  end
  def group_name
    object.name
  end
end
