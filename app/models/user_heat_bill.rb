class UserHeatBill < ApplicationRecord
  belongs_to :user
  belongs_to :heat_bill
end
