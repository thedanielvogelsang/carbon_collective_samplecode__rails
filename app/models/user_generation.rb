class UserGeneration < ApplicationRecord
  belongs_to :parent, :class_name => 'User'
  belongs_to :child, :class_name => 'User'

  after_save :add_accepted_date_to_invitee, :link_parent_to_child

  def add_accepted_date_to_invitee
    child = User.find(self.child_id)
    child.accepted_date = DateTime.now
    child.save
  end

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
