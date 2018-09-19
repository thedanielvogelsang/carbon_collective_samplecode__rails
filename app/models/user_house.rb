class UserHouse < ApplicationRecord
  belongs_to :user
  belongs_to :house

  validates_presence_of :user_id
  validates_presence_of :house_id
  validates_uniqueness_of :user_id, :scope => :house_id

  before_create :update_house_no_residents_add,
                :add_user_questions,
                :find_or_create_user_rankings

  after_create :log_house_creation

  before_save :confirm_move_in

  before_destroy :update_house_no_residents_less

  def add_user_questions
    user = User.find(user_id)
    user.set_all_questions(house_id)
  end

  def find_or_create_user_rankings
    user = User.find(user_id)
    user.set_default_ranks(house_id)
  end

  def update_house_no_residents_add
    house = House.find(self.house_id)
    house.no_residents += 1
    house.save
  end

  def update_house_no_residents_less
    house = House.find(self.house_id)
    house.no_residents -= 1
    house.save
  end

  def log_house_creation
    UserLogHelper.log_house_creation(self.user_id, self.house_id)
  end

  def confirm_move_in
    self.move_in_date ||= self.created_at
  end
end
