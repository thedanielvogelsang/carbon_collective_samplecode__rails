class UserWaterQuestion < ApplicationRecord
  belongs_to :house
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :house_id
  validates_uniqueness_of :house_id, scope: :user_id
end
