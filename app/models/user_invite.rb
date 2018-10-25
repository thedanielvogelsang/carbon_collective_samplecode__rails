class UserInvite < ApplicationRecord
  belongs_to :invite, :class_name => "User"
  belongs_to :user

  validates_presence_of :invite_id,
                        :user_id

  def invited
    User.find(self.invite_id)
  end
end
