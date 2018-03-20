module HouseHelper
  def total_energy_consumption_to_date
    self.users.map{|u| u.total_energy_consumption_to_date}.flatten
              .reduce(0){|s,n| s + n}
  end

  def total_carbon_savings_to_date
    self.users.map{|u| u.total_carbon_savings_to_date}.flatten
              .reduce(0){|s,n| s + n}
  end

  def avg_total_energy_consumption_per_resident
    total_energy_consumption_to_date == 0 ? nil : total_energy_consumption_to_date / self.no_residents
  end

  def avg_monthly_energy_consumption_per_resident
    self.users.map{|u| u.avg_monthly_energy_consumption}.flatten
              .reduce(0){|s,n| s + n} / self.no_residents
  end

  def avg_total_carbon_savings_per_resident
    total_carbon_savings_to_date == 0 ? nil : total_carbon_savings_to_date / self.no_residents
  end

  def avg_monthly_carbon_savings_per_resident
    self.users.map{|u| u.avg_monthly_carbon_savings}.flatten
              .reduce(0){|s,n| s + n} / self.no_residents
  end
end
