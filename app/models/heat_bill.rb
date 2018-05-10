class HeatBill < ApplicationRecord
  belongs_to :house

  validates_presence_of :start_date,
                        :end_date,
                        :total_therms

  after_validation :gas_saved?,
                   :update_users_savings

 def gas_saved?
   self.house.address.city.region.has_gas_average? ? region_comparison : country_comparison
 end

 def region_comparison
   region_per_cap_daily_average = self.house.address.city.region.avg_daily_gas_consumed_per_capita
   num_days = self.end_date - self.start_date
   bill_daily_average = self.total_therms.fdiv(num_days)
   avg_daily_use_per_resident = bill_daily_average.fdiv(self.house.no_residents)
   region_per_cap_daily_average > avg_daily_use_per_resident ? res = true : res = false
   res ? self.gas_saved = ((region_per_cap_daily_average - avg_daily_use_per_resident) * num_days) : self.gas_saved = 0
   res
 end

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

 def update_users_savings
   num_res = self.house.no_residents
   num_days = self.end_date - self.start_date
   therms = self.total_therms.fdiv(num_res)
   users = house.users
   gas_saved = self.gas_saved.fdiv(num_res)
   users.each do |u|
     u.total_heatbill_days_logged += num_days
     u.total_therms_logged += therms
     u.total_gas_savings += gas_saved
     u.save
   end
 end
end
