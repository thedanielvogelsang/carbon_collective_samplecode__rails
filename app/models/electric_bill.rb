class ElectricBill < ApplicationRecord
  belongs_to :house

  validates_presence_of :start_date,
                        :end_date,
                        :total_kwhs

  after_validation :electricity_saved?,
                   :update_users_savings,
                   :update_users_regions_totals

  def electricity_saved?
    self.house.address.neighborhood.city.region.has_average? ? region_comparison : country_comparison
  end

  def region_comparison
    region_per_cap_daily_average = self.house.address.neighborhood.city.region.avg_daily_energy_consumed_per_capita
    num_days = self.end_date - self.start_date
    bill_daily_average = self.total_kwhs.fdiv(num_days)
    avg_daily_use_per_resident = bill_daily_average.fdiv(self.house.no_residents)
    region_per_cap_daily_average > avg_daily_use_per_resident ? res = true : res = false
    res ? self.electricity_saved = ((region_per_cap_daily_average - avg_daily_use_per_resident) * num_days) : self.electricity_saved = 0
    res
  end

  def country_comparison
    country_per_cap_daily_average = self.house.address.neighborhood.city.region.country.avg_daily_energy_consumed_per_capita
    num_days = self.end_date - self.start_date
    bill_daily_average = self.total_kwhs.fdiv(num_days)
    avg_daily_use_per_resident = bill_daily_average.fdiv(self.house.no_residents)
    country_per_cap_daily_average > avg_daily_use_per_resident ? res = true : res = false
    res ? self.electricity_saved = ((country_per_cap_daily_average - avg_daily_use_per_resident) * num_days) : self.electricity_saved = 0
    res
  end

  def update_users_savings
    num_res = self.house.no_residents
    num_days = self.end_date - self.start_date
    kwhs = self.total_kwhs.fdiv(num_res)
    users = house.users
    elect_saved = self.electricity_saved.fdiv(num_res)
    users.each do |u|
      u.total_days_logged += num_days
      u.total_kwhs_logged += kwhs
      u.total_electricity_savings += elect_saved
      u.save
    end
    update_users_regions_totals(elect_saved)
  end
end
