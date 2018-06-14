class UserElectricityQuestion < ApplicationRecord
  belongs_to :house
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :house_id
  validates_uniqueness_of :house_id, scope: :user_id

  before_save :update_completion

  def update_completion
    ct = 0;
    self.quest1 ? ct += 1 : nil
    self.quest2 ? ct += 1 : nil
    self.quest3 ? ct += 1 : nil
    self.quest5 ? ct += 1 : nil
    self.a_count = ct
    self.completion_percentage = self.a_count.fdiv(self.q_count) * 100
    self.completion_percentage.to_i == 100 ? self.completed = true : nil
  end
end
