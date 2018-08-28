class HeatBill < ApplicationRecord
  include Co2Helper

  belongs_to :house
  belongs_to :who, class_name: 'User', foreign_key: :user_id


  validates_presence_of :start_date,
                        :end_date,
                        :total_therms,
                        :no_residents

  validate :confirm_no_overlaps, :confirm_valid_dates, :check_move_in_date

  after_validation :gas_saved?,
                   :update_users_savings

  after_create :log_user_activity

 #checks if region_comparisons can be made or not; returns boolean either way
 def gas_saved?
   self.house.address.city.region.has_gas_average? ? region_comparison : country_comparison
 end

 # primary regional avg comparison
 def region_comparison
   region_per_cap_daily_average = self.house.address.city.region.avg_daily_gas_consumed_per_capita
   num_days = self.end_date - self.start_date
   bill_daily_average = self.total_therms.fdiv(num_days)
   avg_daily_use_per_resident = bill_daily_average.fdiv(self.house.no_residents)
   region_per_cap_daily_average > avg_daily_use_per_resident ? res = true : res = false
   res ? self.gas_saved = ((region_per_cap_daily_average - avg_daily_use_per_resident) * num_days) : self.gas_saved = 0
   res
 end

 # backup comparison when creating electricity savings
 def country_comparison
   country_per_cap_daily_average = self.house.address.city.region.country.avg_daily_gas_consumed_per_capita
   if country_per_cap_daily_average
     num_days = self.end_date - self.start_date
     bill_daily_average = self.total_therms.fdiv(num_days)
     avg_daily_use_per_resident = bill_daily_average.fdiv(self.house.no_residents)
     country_per_cap_daily_average > avg_daily_use_per_resident ? res = true : res = false
     res ? self.gas_saved = ((country_per_cap_daily_average - avg_daily_use_per_resident) * num_days) : self.gas_saved = 0
   else
     res = false
     self.gas_saved = 0
   end
   res
 end

 # at the end of bill making, updates all users in house at current time to hold their totals
 def update_users_savings
   num_res = self.no_residents
   num_days = self.end_date - self.start_date
   therms = self.total_therms.fdiv(num_res)
   gas_saved = self.gas_saved.fdiv(num_res)
   house = House.find(house_id)
   users = UserHouse.joins(:house).where(house_id: house_id).select{|uh| uh.move_in_date.to_datetime <= self.start_date}
   users = users.map{|uh| User.find(uh.user_id)}
   users.each do |u|
     u.total_heatbill_days_logged += num_days
     u.total_therms_logged += therms
     u.total_pounds_logged += therms_to_carbon(therms)
     u.total_gas_savings += gas_saved
     u.total_carbon_savings += therms_to_carbon(gas_saved)
     u.save
   end
   house.update_data
 end

 def confirm_no_overlaps
   start_ = self.start_date
   end_ = self.end_date
   past_bills = HeatBill.where(house_id: self.house_id)
   overlaps = past_bills.select do |b|
     check_overlap(start_, end_, b.start_date, b.end_date)
   end
   overlaps.empty? ? true : errors.add(:start_date, "start or end date overlaps with another bill")
 end

 def check_overlap(a_st, a_end, b_st, b_end)
   (a_st < b_end) && (a_end > b_st)
 end

 def log_user_activity
   UserLogHelper.user_adds_bill(self.user_id, 'heat')
 end

 def check_move_in_date
   uH_movein = UserHouse.where(user_id: user_id, house_id: house_id)[0].move_in_date.to_datetime
   start_date >= uH_movein ? true : errors.add(:start_date, "user moved in after bill cycle")
 end

 def confirm_valid_dates
   end_date <= DateTime.now ? true : errors.add(:end_date, "cannot claim future use on past bills")
 end
end
