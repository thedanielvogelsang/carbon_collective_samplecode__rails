class UserWaterBill < ApplicationRecord
  belongs_to :user
  belongs_to :water_bill
end
