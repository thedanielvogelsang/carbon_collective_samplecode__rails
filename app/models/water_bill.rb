class WaterBill < ApplicationRecord
  belongs_to :house
  belongs_to :who, class_name: 'User', foreign_key: :user_id

  validates_presence_of :start_date,
                        :end_date,
                        :total_gallons,
                        :no_residents

  validate :confirm_no_overlaps, :confirm_valid_dates, :check_move_in_date

  after_validation :water_saved?,
                   :update_users_savings

  after_create :log_user_activity

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
    num_res = self.no_residents
    num_days = self.end_date - self.start_date
    gals = self.total_gallons.fdiv(num_res)
    water_saved = self.water_saved.fdiv(num_res)
    users = UserHouse.joins(:house).where(house_id: house_id).select{|uh| uh.move_in_date.to_datetime <= self.start_date}
    house = House.find(house_id)
    users = users.map{|uh| User.find(uh.user_id)}
    users.each do |u|
      u.total_waterbill_days_logged += num_days
      u.total_gallons_logged += gals
      u.total_water_savings += water_saved
      u.save
    end
    house.update_data
  end

  def confirm_no_overlaps
    start_ = self.start_date
    end_ = self.end_date
    past_bills = WaterBill.where(house_id: self.house_id)
    overlaps = past_bills.select do |b|
      check_overlap(start_, end_, b.start_date, b.end_date)
    end
    overlaps.empty? ? true : errors.add(:start_date, "start or end date overlaps with another bill")
  end

  def check_overlap(a_st, a_end, b_st, b_end)
    (a_st < b_end) && (a_end > b_st)
  end

  def log_user_activity
    UserLogHelper.user_adds_bill(self.user_id, 'water')
  end

  def check_move_in_date
    uH_movein = UserHouse.where(user_id: user_id, house_id: house_id)[0].move_in_date.to_datetime
    start_date >= uH_movein ? true : errors.add(:start_date, "user moved in after bill cycle")
  end

  def confirm_valid_dates
    end_date <= DateTime.now ? true : errors.add(:end_date, "cannot claim future use on past bills")
  end
end
