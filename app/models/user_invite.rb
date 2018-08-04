class UserInvite < ApplicationRecord

  def invited
    User.find(self.invite_id)
  end
end
