class ElectricBill < ApplicationRecord
  belongs_to :house

  validates_presence_of :start_date,
                        :end_date,
                        :total_kwhs

  after_validation :co2_saved?

  def co2_saved?
    897 > self.total_kwhs.to_f ? res = true : res = false
    res ? self.carbon_saved = (897 - self.total_kwhs.to_f) : nil
    res
  end

end
