class CheckInviteJob < ApplicationJob
  queue_as :default

  def perform(user)
    if(user.user_invites.order(:created_at).last.created_at >= DateTime.now - 10 && !user.completed_signup?)
      user.destroy
    end
  end
end
