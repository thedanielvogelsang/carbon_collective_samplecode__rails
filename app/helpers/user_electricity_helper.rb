module UserElectricityHelper

  include UserHelper

  def avg_daily_electricity_savings
    self.total_kwhs_logged / self.total_electricitybill_days_logged
  end

  def avg_daily_electricity_consumption
    self.total_kwhs_logged.fdiv(self.total_electricitybill_days_logged)
  end

# check
  def household_daily_electricity_consumption
    household ? household.average_daily_electricity_consumption_per_resident : nil
  end

  def neighborhood_daily_electricity_consumption
    household.address.neighborhood ? household.address.neighborhood.avg_daily_electricity_consumed_per_user : nil
  end

  def city_daily_electricity_consumption
    household ? household.address.city.avg_daily_electricity_consumed_per_user : nil
  end

  def county_daily_electricity_consumption
    household ? household.address.county.avg_daily_electricity_consumed_per_user : nil
  end

  def region_daily_electricity_consumption
    household ? household.address.city.region.avg_daily_electricity_consumed_per_user : nil
  end

  def country_daily_electricity_consumption
    household ? household.address.city.region.country.avg_daily_electricity_consumed_per_user : nil
  end

end
