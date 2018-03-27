module CityHelper
  def total_electricity_consumption_to_date
    self.users.map{|u| u.total_electricity_consumption_to_date}.flatten
              .reduce(0){|s,n| s + n}
  end

  def total_electricity_savings_to_date
    self.users.map{|u| u.total_electricity_savings_to_date}.flatten
              .reduce(0){|s,n| s + n}
  end

  def avg_total_electricity_consumption_per_capita
    total_electricity_consumption_to_date / self.users.count
  end

  def avg_monthly_electricity_consumption_per_capita
    self.users.map{|u| u.avg_monthly_electricity_consumption}.flatten
              .reduce(0){|s,n| s + n} / self.users.count
  end

  def avg_total_electricity_savings_per_capita
    total_electricity_savings_to_date / self.users.count
  end

  def avg_monthly_electricity_savings_per_capita
    self.users.map{|u| u.avg_monthly_electricity_savings}.flatten
              .reduce(0){|s,n| s + n} / self.users.count
  end
end
