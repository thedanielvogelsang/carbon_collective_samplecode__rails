class UserGeneration < ApplicationRecord
  belongs_to :parent, :class_name => 'User'
  belongs_to :child, :class_name => 'User'

  after_save :link_parent_to_child

  def link_parent_to_child
    parent = User.find(self.parent_id)
    child = User.find(self.child_id)
    child.parent_id = parent.id
    child.save
  end

  def self.bind_generations(user, orig_id)
    if user.parent
      parent = user.parent
      UserGeneration.find_or_create_by(parent_id: parent.id, child_id: orig_id)
      bind_generations(parent, orig_id)
    end
  end
end
