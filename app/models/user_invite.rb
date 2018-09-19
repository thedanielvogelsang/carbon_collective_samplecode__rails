class UserInvite < ApplicationRecord

  validates_presence_of :invite_id,
                        :user_id

  def invited
    User.find(self.invite_id)
  end
end
