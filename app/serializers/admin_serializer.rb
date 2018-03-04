class AdminSerializer < ActiveModel::Serializer
  attributes :groups

  def groups
    groups = {}
    object.groups.each_with_index{|g, i| groups[g.id] = g.name}
    groups
  end
end
