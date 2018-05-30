module UserElectricityHelper

  include UserHelper

  def avg_daily_electricity_savings
    self.total_kwhs_logged / self.total_electricitybill_days_logged
  end

  def avg_daily_electricity_consumption
    self.total_kwhs_logged.fdiv(self.total_electricitybill_days_logged)
  end

# check
  def household_total_electricity_savings
    household ? household.total_electricity_savings_to_date : nil
  end

  def neighborhood_total_electricity_savings
    household.address.neighborhood ? household.address.neighborhood.total_electricity_saved : nil
  end

  def city_total_electricity_savings
    household ? household.address.city.total_electricity_saved : nil
  end

  def county_total_electricity_savings
    household ? household.address.county.total_electricity_saved : nil
  end

  def region_total_electricity_savings
    household ? household.address.city.region.total_electricity_saved : nil
  end

  def country_total_electricity_savings
    household ? household.address.city.region.country.total_electricity_saved : nil
  end

end
