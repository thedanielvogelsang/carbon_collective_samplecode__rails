module HouseHelper
  # 0.4 ms vs 0.7 w/ users
  def total_electricity_savings_to_date
    self.bills.map{|b| b.electricity_saved}.flatten
              .reduce(0){|s,n| s + n}
  end

  def total_water_savings_to_date
    self.water_bills.map{|wb| wb.water_saved}.flatten
              .reduce(0){|s,n| s + n}
  end

  ## used for snapshots -- pending api use ##
  # 0.5 ms
  def average_daily_electricity_consumption_per_resident
    self.users.map{|u| u.avg_daily_electricity_consumption}.flatten
              .reduce(0){|s,n| s + n} / self.no_residents
  end

  #
  def average_total_electricity_saved_per_resident
    total_electricity_savings_to_date / self.no_residents
  end

  def total_electricity_saved
    total_electricity_savings_to_date
  end

  def total_electricity_consumption_to_date
    self.bills.map{|b| b.total_kwhs }.flatten.reduce(0){|s,n| s+n}
  end

  def avg_total_electricity_consumption_per_resident
    total_electricity_consumption_to_date / self.no_residents
  end

  def avg_total_electricity_savings_per_resident
    total_electricity_saved / self.no_residents
  end
  #

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
