module UserGasHelper
  include UserHelper
  #
  # def avg_daily_gas_savings
  #   self.total_therms_logged / self.total_heatbill_days_logged
  # end

  def avg_daily_gas_consumption
    self.total_therms_logged.fdiv(self.total_heatbill_days_logged)
  end

# check
  def household_daily_gas_consumption_per_user
    household ? household.average_daily_gas_consumption_per_user : nil
  end

  def neighborhood_daily_gas_consumption_per_user
    household.address.neighborhood ? household.address.neighborhood.avg_daily_gas_consumed_per_user : nil
  end

  def city_daily_gas_consumption_per_user
    household ? household.address.city.avg_daily_gas_consumed_per_user : nil
  end

  def county_daily_gas_consumption_per_user
    household ? household.address.county.avg_daily_gas_consumed_per_user : nil
  end

  def region_daily_gas_consumption_per_user
    household ? household.address.city.region.avg_daily_gas_consumed_per_user : nil
  end

  def country_daily_gas_consumption_per_user
    household ? household.address.city.region.country.avg_daily_gas_consumed_per_user : nil
  end

end
