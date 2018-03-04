class AdminLongSerializer < ActiveModel::Serializer
  attributes :id, :admin_username, :groups

  def admin_username
    object.user.username
  end

  def groups
    groups = {}
    object.groups.each_with_index{|g, i| groups[g.id] = g.name}
    groups
  end
end
