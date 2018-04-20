module CityHelper
  def update_data
    update_total_savings
    update_daily_avg_consumption
    update_daily_avg_savings
    self.save
  end

  def update_total_savings
    energy_saved = self.users.map{|u| u.total_electricity_savings}.flatten
              .reduce(0){|sum, num| sum + num}
    self.total_energy_saved = energy_saved
  end

  def update_daily_avg_consumption
    energy_consumed = self.users.map{|u| u.avg_daily_electricity_consumption }.flatten
            .reduce(0){|sum, num| sum + num} / self.users.count
    self.avg_daily_energy_consumed_per_user = energy_consumed
  end

  def update_daily_avg_savings
    energy_savings = self.users.map{|u| u.total_electricity_savings }.flatten
            .reduce(0){|sum, num| sum + num } / self.users.count
    self.avg_total_energy_saved_per_user = energy_savings
  end
end
