class HeatBill < ApplicationRecord
  include Co2Helper
  include MathHelper

  belongs_to :house
  belongs_to :who, class_name: 'User', foreign_key: :user_id
  has_many :user_heat_bills


  validates_presence_of :start_date,
                        :end_date,
                        :total_therms,
                        :no_residents,
                        :user_id,
                        :house_id

  validate :detect_outlier, :confirm_no_overlaps, :confirm_valid_dates, :check_move_in_date

  after_validation :gas_saved?,
                   :update_no_residents_on_house

  after_create :log_user_activity, :add_to_users_totals

  before_destroy :subtract_from_users_totals

 #checks if region_comparisons can be made or not; returns boolean either way
 def gas_saved?
   if self.house
     self.house.address.city.region.has_gas_average? ? region_comparison : country_comparison
   else
     false
   end
 end

 def update_no_residents_on_house
   if house_id && no_residents
     House.find(house_id).update(no_residents: self.no_residents)
   end
 end

 # primary regional avg comparison
 def region_comparison
   region_per_cap_daily_average = self.house.address.city.region.avg_daily_gas_consumed_per_capita
   if region_per_cap_daily_average
     num_days = self.end_date - self.start_date
     bill_daily_average = self.total_therms.fdiv(num_days)
     avg_daily_use_per_resident = bill_daily_average.fdiv(self.house.no_residents)
     region_per_cap_daily_average > avg_daily_use_per_resident ? res = true : res = false
     res ? self.gas_saved = ((region_per_cap_daily_average - avg_daily_use_per_resident) * num_days) : self.gas_saved = 0
   else
     res = false
     self.gas_saved = 0
   end
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
 def add_to_users_totals
   if user_id && house_id && start_date && end_date
     therms = self.average_daily_usage
     house = House.find(house_id)
     users_after_date = UserHouse.joins(:house)
                                .where(house_id: house_id)
                                .select{|uh| (uh.move_in_date.to_datetime - 1) <= self.start_date}
     users = users_after_date.map{|uh| User.find(uh.user_id)}
     gas_saved = self.gas_saved.fdiv(self.no_residents)
     num_days = self.end_date - self.start_date
     users.each do |u|
       u.total_heatbill_days_logged += num_days
       u.total_therms_logged += (total_therms.fdiv(no_residents))
       u.total_pounds_logged += therms_to_carbon(therms)
       u.total_gas_savings += gas_saved
       u.total_carbon_savings += therms_to_carbon(gas_saved)
       UserHeatBill.find_or_create_by(user_id: u.id, heat_bill_id: self.id)
       u.save
     end
     house.update_data
     house.update_user_rankings
   else
     false
   end
 end

 # before_destroy action
 def subtract_from_users_totals
   therms = self.average_daily_usage
   # users = UserHouse.joins(:house).where(house_id: house_id).select{|uh| (uh.move_in_date.to_datetime - 1) <= self.start_date}
   house = House.find(house_id)
   users = User.joins(:user_heat_bills)
               .where(:user_heat_bills => {heat_bill_id: id})
               .merge(house.users)
   gas_saved = self.gas_saved.fdiv(self.no_residents)
   num_days = self.end_date - self.start_date
   users.each do |u|
     u.total_heatbill_days_logged -= num_days
     u.total_therms_logged -= (total_therms.fdiv(no_residents))
     u.total_pounds_logged -= therms_to_carbon(therms)
     u.total_gas_savings -= gas_saved
     u.total_carbon_savings -= therms_to_carbon(gas_saved)
     u.save
   end
   house.update_data
   house.update_user_rankings
 end

 def confirm_no_overlaps
   start_ = self.start_date
   end_ = self.end_date
   past_bills = HeatBill.where(house_id: self.house_id)
   overlaps = past_bills.select do |b|
     check_overlap(start_, end_, b.start_date, b.end_date)
   end
   overlaps = overlaps - [self]
   pp overlaps
   overlaps.empty? ? true : errors.add(:start_date, "start or end date overlaps with another bill")
 end

 def check_overlap(a_st=0, a_end=0, b_st, b_end)
   (a_st < b_end) && (a_end > b_st)
 end

 def detect_outlier
   if no_residents && end_date && start_date && total_therms
     num_days = self.end_date - self.start_date
     therms = self.total_therms.fdiv(num_days).fdiv(no_residents)
   end
   self.average_daily_usage = therms || 0
   usages = HeatBill.pluck(:average_daily_usage).sort
     unless usages.count < 10
       q1_q3 = find_q1_q3(usages)
       min = 0
       iqr = q1_q3[1] - q1_q3[0]
     end
     usages.count < 10 ? max = 7 : max = 1.5*iqr + q1_q3[1]
   return average_daily_usage > 0 && average_daily_usage <= max ? true : force ? true : errors.add(:total_kwhs, "resource usage is much higher than average, are you sure you want to proceed?")
 end

 def log_user_activity
   UserLogHelper.user_adds_bill(self.user_id, 'heat')
 end

 def check_move_in_date
   uh = UserHouse.where(user_id: user_id, house_id: house_id)[0]
   uh ? uH_movein = uh.move_in_date.to_datetime : uH_movein = 0
   start_date >= (uH_movein - 1) ? true : errors.add(:start_date, "update your move in date to save in that timeframe")
 end

 def confirm_valid_dates
   if end_date && start_date
     end_date >= start_date ? true : errors.add(:end_date, "must come after start_date of bill")
     end_date <= DateTime.now ? true : errors.add(:end_date, "cannot claim future use on past bills")
   else
     false
   end
 end

 def self.updated?(bill, updates)
   updates.keys.each do |key|
     key == "start_date" || key == "end_date" ? value = Date.parse(updates[key]) : value = updates[key]
     bill[key] = value
   end
   bill.save ? true : false
 end
end
