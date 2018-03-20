module RegionHelper
  def total_energy_consumption_to_date
    self.users.map{|u| u.total_energy_consumption_to_date}.flatten
              .reduce(0){|s,n| s + n}
  end

  def total_carbon_savings_to_date
    self.users.map{|u| u.total_carbon_savings_to_date}.flatten
              .reduce(0){|s,n| s + n}
  end

  def avg_total_energy_consumption_per_capita
    total_energy_consumption_to_date / self.users.count
  end

  def avg_monthly_energy_consumption_per_capita
    self.users.map{|u| u.avg_monthly_energy_consumption}.flatten
              .reduce(0){|s,n| s + n} / self.users.count
  end

  def avg_total_carbon_savings_per_capita
    total_carbon_savings_to_date / self.users.count
  end

  def avg_monthly_carbon_savings_per_capita
    self.users.map{|u| u.avg_monthly_carbon_savings}.flatten
              .reduce(0){|s,n| s + n} / self.users.count
  end
end
