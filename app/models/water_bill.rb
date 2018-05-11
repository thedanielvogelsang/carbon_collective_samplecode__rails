class WaterBill < ApplicationRecord
  belongs_to :house

  validates_presence_of :start_date,
                        :end_date,
                        :total_gallons

  after_validation :water_saved?,
                   :update_users_savings

  def water_saved?
    self.house.address.city.region.has_water_average? ? region_comparison : country_comparison
  end

  def region_comparison
    region_per_cap_daily_average = self.house.address.city.region.avg_daily_water_consumed_per_capita
    num_days = self.end_date - self.start_date
    bill_daily_average = self.total_gallons.fdiv(num_days)
    avg_daily_use_per_resident = bill_daily_average.fdiv(self.house.no_residents)
    region_per_cap_daily_average > avg_daily_use_per_resident ? res = true : res = false
    res ? self.water_saved = ((region_per_cap_daily_average - avg_daily_use_per_resident) * num_days) : self.water_saved = 0
    res
  end

  def country_comparison
    country_per_cap_daily_average = self.house.address.city.region.country.avg_daily_water_consumed_per_capita
    num_days = self.end_date - self.start_date
    bill_daily_average = self.total_gallons.fdiv(num_days)
    avg_daily_use_per_resident = bill_daily_average.fdiv(self.house.no_residents)
    country_per_cap_daily_average > avg_daily_use_per_resident ? res = true : res = false
    res ? self.water_saved = ((country_per_cap_daily_average - avg_daily_use_per_resident) * num_days) : self.water_saved = 0
    res
  end

  def update_users_savings
    num_res = self.house.no_residents
    num_days = self.end_date - self.start_date
    gals = self.total_gallons.fdiv(num_res)
    users = house.users
    water_saved = self.water_saved.fdiv(num_res)
    users.each do |u|
      u.total_waterbill_days_logged += num_days
      u.total_gallons_logged += gals
      u.total_water_savings += water_saved
      u.save
    end
  end

end
