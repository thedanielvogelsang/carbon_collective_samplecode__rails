module HouseHelper
  include Co2Helper
  # 0.4 ms vs 0.7 w/ users
  def total_electricity_savings_to_date
    self.bills.map{|b| b.electricity_saved}.flatten
              .reduce(0){|s,n| s + n}
  end

  def total_water_savings_to_date
    self.water_bills.map{|wb| wb.water_saved}.flatten
              .reduce(0){|s,n| s + n}
  end

  def total_gas_savings_to_date
    self.heat_bills.map{|hb| hb.gas_saved}.flatten
              .reduce(0){|s,n| s + n}
  end

  def total_carbon_savings_to_date
    return combine_average_use(total_electricity_savings_to_date,
                              total_gas_savings_to_date,
                              )
  end

  ## used for snapshots -- pending api use ##
  # 0.5 ms
  def average_daily_electricity_consumption_per_user
    # self.electric_bills.map{|b| b.total_kwhs_logged}.compact.flatten.reject(&:nan?)
    #           .reduce(0){|s, n| s + n} / self.no_residents
    self.users.map{|u| u.avg_daily_electricity_consumption}.compact.flatten.reject(&:nan?)
              .reduce(0){|s,n| s + n} / self.users.count
  end

  def average_daily_electricity_consumption_per_resident
    # self.electric_bills.map{|b| b.total_kwhs_logged}.compact.flatten.reject(&:nan?)
    #           .reduce(0){|s, n| s + n} / self.no_residents
    self.users.map{|u| u.avg_daily_electricity_consumption}.compact.flatten.reject(&:nan?)
              .reduce(0){|s,n| s + n} / self.no_residents
  end

  #
  def average_total_electricity_saved_per_resident
    total_electricity_savings_to_date / self.no_residents
  end

  def average_daily_water_consumption_per_user
    # self.water_bills.map{|b| b.total_gallons_logged}.compact.flatten.reject(&:nan?)
    #           .reduce(0){|s, n| s + n} / self.users.count
    self.users.map{|u| u.avg_daily_water_consumption}.compact.flatten.reject(&:nan?)
              .reduce(0){|s,n| s + n} / self.users.count
  end

  def average_daily_water_consumption_per_resident
    # self.water_bills.map{|b| b.total_gallons_logged}.compact.flatten.reject(&:nan?)
    #           .reduce(0){|s, n| s + n} / self.users.count
    self.users.map{|u| u.avg_daily_water_consumption}.compact.flatten.reject(&:nan?)
              .reduce(0){|s,n| s + n} / self.no_residents
  end

  #
  def average_total_water_saved_per_resident
    total_water_savings_to_date / self.no_residents
  end

  def average_daily_gas_consumption_per_user
    # self.heat_bills.map{|b| b.total_therms_logged}.compact.flatten.reject(&:nan?)
    #           .reduce(0){|s, n| s + n} / self.users.count
    self.users.map{|u| u.avg_daily_gas_consumption}.compact.flatten.reject(&:nan?)
              .reduce(0){|s,n| s + n} / self.users.count
  end
  def average_daily_gas_consumption_per_resident
    # self.heat_bills.map{|b| b.total_therms_logged}.compact.flatten.reject(&:nan?)
    #           .reduce(0){|s, n| s + n} / self.users.count
    self.users.map{|u| u.avg_daily_gas_consumption}.compact.flatten.reject(&:nan?)
              .reduce(0){|s,n| s + n} / self.no_residents
  end

  #
  def average_total_gas_saved_per_resident
    total_gas_savings_to_date / self.no_residents
  end

  def average_daily_carbon_consumption_per_user
    self.users.map{|u| u.avg_daily_carbon_consumption}.compact.flatten.reject(&:nan?)
              .reduce(0){|s,n| s + n} / self.users.count
  end

  #
  def average_total_carbon_saved_per_resident
    total_carbon_savings_to_date / self.no_residents
  end

  def total_electricity_saved
    total_electricity_savings_to_date
  end

  def total_water_saved
    total_water_savings_to_date
  end

  def total_gas_saved
    total_gas_savings_to_date
  end

  def total_days_recorded
    self.bills.map{|b| (b.end_date - b.start_date).to_i }.reduce(0){|s, n| s + n}
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

  def total_water_consumption_to_date
    self.water_bills.map{|b| b.total_gallons }.flatten.reduce(0){|s,n| s+n}
  end

  def avg_total_water_consumption_per_resident
    total_water_consumption_to_date / self.no_residents
  end

  def avg_total_water_savings_per_resident
    total_water_saved / self.no_residents
  end

  def total_gas_consumption_to_date
    self.heat_bills.map{|b| b.total_therms }.flatten.reduce(0){|s,n| s+n}
  end

  def avg_total_gas_consumption_per_resident
    total_gas_consumption_to_date / self.no_residents
  end

  def avg_total_gas_savings_per_resident
    total_gas_saved / self.no_residents
  end

  def total_carbon_consumption_to_date
    combine_average_use(
        total_electricity_consumption_to_date, total_gas_consumption_to_date
        )
  end

  def avg_total_carbon_consumption_per_resident
    total_carbon_consumption_to_date / self.no_residents
  end

  def avg_total_carbon_savings_per_resident
    total_gas_saved / self.no_residents
  end

  def total_spent
    total = []
    self.water_bills.empty? ? nil : self.water_bills.each{ |b| total.push(b.price)}
    self.heat_bills.empty? ? nil : self.heat_bills.each{|b| total.push(b.price)}
    self.electric_bills.empty? ? nil : self.bills.each{|b| total.push(b.price)}
    total.reject(&:nil?).reduce(0){|s, n| s + n}.to_f.round(2)
  end

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
