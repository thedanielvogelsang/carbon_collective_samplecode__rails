class UserElectricBill < ApplicationRecord
  belongs_to :user
  belongs_to :electric_bill
end
