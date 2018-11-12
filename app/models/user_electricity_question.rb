class UserElectricityQuestion < ApplicationRecord
  belongs_to :house
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :house_id
  validates_uniqueness_of :house_id, scope: :user_id

  before_save :questionairre_complete
  after_save :update_completion

  def update_completion
    ct = 0;
    self.quest1 ? ct += 1 : nil
    self.quest2 ? ct += 1 : nil
    self.quest3 ? ct += 1 : nil
    self.quest5 ? ct += 1 : nil
    self.a_count = ct
    self.completion_percentage = self.a_count.fdiv(self.q_count) * 100
    self.completion_percentage.to_i == 100 ? questionairre_complete : nil
  end

  def questionairre_complete
    if self.completion_percentage.to_i == 100
      self.completed = true
      UserLogHelper.user_completes_questionairre(self.user_id, "electricity")
    end
  end

  def update_with_params(q, a)
    if q == 'quest1'
      self.quest1 = a
    elsif q == 'quest2'
      self.quest2 = a
    elsif q == 'quest3'
      self.quest3 = a
    elsif q == 'quest4'
      self.quest4 = a
    elsif q == 'quest5'
      self.quest5 = a
    end
    self.save
  end

  def clear_all
    self.quest1 = nil
    self.quest2 = nil
    self.quest3 = nil
    self.quest4 = nil
    self.quest5 = nil
    self.save
  end

end
