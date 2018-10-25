class UserInvite < ApplicationRecord
  belongs_to :invite, :class_name => "User"
  belongs_to :user

  validates_presence_of :invite_id,
                        :user_id

  after_create :call_10_day_check

  def invited
    User.find(self.invite_id)
  end

  def call_10_day_check
    CheckInviteJob.set(wait: 10.days).perform_later(User.find(self.invite_id))
  end
end
