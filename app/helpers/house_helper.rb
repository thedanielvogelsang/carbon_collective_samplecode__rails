module HouseHelper

  def total_electricity_savings_to_date
    self.users.map{|u| u.total_electricity_savings}.flatten
              .reduce(0){|s,n| s+n}
  end

  ## no use yet ##

  # def avg_total_electricity_consumption_per_resident
  #   total_electricity_consumption_to_date == 0 ? nil : total_electricity_consumption_to_date / self.no_residents
  # end
  #
  # def avg_monthly_electricity_consumption_per_resident
  #   self.users.map{|u| u.avg_monthly_electricity_consumption}.flatten
  #             .reduce(0){|s,n| s + n} / self.no_residents
  # end
  #
  # def avg_total_electricity_savings_per_resident
  #   total_electricity_savings_to_date == 0 ? nil : total_electricity_savings_to_date / self.no_residents
  # end
  #
  # def avg_monthly_electricity_savings_per_resident
  #   self.users.map{|u| u.avg_monthly_electricity_savings}.flatten
  #             .reduce(0){|s,n| s + n} / self.no_residents
  # end
end
