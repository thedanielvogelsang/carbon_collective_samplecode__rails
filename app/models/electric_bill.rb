class ElectricBill < ApplicationRecord
  belongs_to :house

  validates_presence_of :start_date,
                        :end_date,
                        :total_kwhs

  after_validation :electricity_saved?

  def electricity_saved?
    country_monthly_average = self.house.address.neighborhood.city.region.country.mepc
    country_monthly_average > self.total_kwhs.to_f ? res = true : res = false
    res ? self.electricity_saved = (country_monthly_average - self.total_kwhs.to_f) : nil
    res
  end

end
