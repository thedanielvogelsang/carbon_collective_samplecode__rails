class UserHouse < ApplicationRecord
  belongs_to :user
  belongs_to :house

  validates_uniqueness_of :user_id, :scope => :house_id

  # before_create :update_house_no_residents_add
  before_destroy :update_house_no_residents_less

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
end
