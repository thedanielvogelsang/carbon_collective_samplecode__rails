class ElectricBill < ApplicationRecord
  include Co2Helper

  belongs_to :house

    validates_presence_of :start_date,
                          :end_date,
                          :total_kwhs,
                          :no_residents

    validate :confirm_valid_dates

    after_validation :electricity_saved?,
                     :update_users_savings

  #checks if region_comparisons can be made or not; returns boolean either way
  def electricity_saved?
    self.house.address.city.region.has_electricity_average? ? region_comparison : country_comparison
  end

  # primary regional avg comparison
  def region_comparison
    region_per_cap_daily_average = self.house.address.city.region.avg_daily_electricity_consumed_per_capita
    num_days = self.end_date - self.start_date
    bill_daily_average = self.total_kwhs.fdiv(num_days)
    avg_daily_use_per_resident = bill_daily_average.fdiv(self.no_residents)
    region_per_cap_daily_average > avg_daily_use_per_resident ? res = true : res = false
    res ? self.electricity_saved = ((region_per_cap_daily_average - avg_daily_use_per_resident) * num_days) : self.electricity_saved = 0
    res
  end

  # backup comparison when creating electricity savings
  def country_comparison
    country_per_cap_daily_average = self.house.address.city.region.country.avg_daily_electricity_consumed_per_capita
    num_days = self.end_date - self.start_date
    bill_daily_average = self.total_kwhs.fdiv(num_days)
    avg_daily_use_per_resident = bill_daily_average.fdiv(self.no_residents)
    country_per_cap_daily_average > avg_daily_use_per_resident ? res = true : res = false
    res ? self.electricity_saved = ((country_per_cap_daily_average - avg_daily_use_per_resident) * num_days) : self.electricity_saved = 0
    res
  end

  # at the end of bill making, updates all users in house at current time to hold their totals
  def update_users_savings
    num_res = self.no_residents
    num_days = self.end_date - self.start_date
    kwhs = self.total_kwhs.fdiv(num_res)
    users = house.users
    elect_saved = self.electricity_saved.fdiv(num_res)
    users.each do |u|
      u.total_electricitybill_days_logged += num_days
      u.total_kwhs_logged += kwhs
      u.total_pounds_logged += kwhs_to_carbon(kwhs)
      u.total_electricity_savings += elect_saved
      u.total_carbon_savings += kwhs_to_carbon(elect_saved)
      u.save
    end
  end

  def confirm_valid_dates
    start_ = self.start_date
    end_ = self.end_date
    past_bills = ElectricBill.where(house_id: self.house_id)
    overlaps = past_bills.select do |b|
      check_overlap(start_, end_, b.start_date, b.end_date)
    end
    overlaps.empty? ? true : errors.add(:start_date, "start or end date overlaps with another bill")
  end

  def check_overlap(a_st, a_end, b_st, b_end)
    (a_st < b_end) && (a_end > b_st)
  end
end
