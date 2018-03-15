class ElectricBill < ApplicationRecord
  belongs_to :user

  validates_presence_of :start_date,
                        :end_date,
                        :total_kwhs
end
