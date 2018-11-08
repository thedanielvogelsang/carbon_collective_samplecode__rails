class CalculateUserScoreJob < ApplicationJob
  queue_as :default

  def perform(user, original_move_in_date)
    user.re_calculate_bill_history(original_move_in_date)
  end
end
