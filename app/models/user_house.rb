class UserHouse < ApplicationRecord
  belongs_to :user
  belongs_to :house

  validates_presence_of :user_id
  validates_presence_of :house_id
  validates_uniqueness_of :user_id, :scope => :house_id

  before_create :update_house_no_residents_add, :add_user_questions
  after_create :log_house_creation, :confirm_move_in

  before_destroy :update_house_no_residents_less

  def add_user_questions
    UserElectricityQuestion.find_or_create_by(user_id: user_id, house_id: house_id)
    UserGasQuestion.find_or_create_by(user_id: user_id, house_id: house_id)
    UserWaterQuestion.find_or_create_by(user_id: user_id, house_id: house_id)
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
    self.save
  end
end
