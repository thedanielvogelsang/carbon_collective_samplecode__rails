module UserCarbonHelper
  include UserHelper
  include Co2Helper

  def avg_daily_carbon_savings
    user_date = account_length_time
    self.total_pounds_logged / user_date.to_i
  end

  def avg_daily_carbon_consumption
    res_ = combine_average_use(self.avg_daily_electricity_consumption, self.avg_daily_gas_consumption)
    return res_.fdiv(self.total_electricitybill_days_logged) if res_ != 0
  end

# check
  def household_total_carbon_savings
    household ? household.total_carbon_savings_to_date : nil
  end

  def neighborhood_total_carbon_savings
    household.address.neighborhood ? household.address.neighborhood.total_carbon_saved : nil
  end

  def city_total_carbon_savings
    household ? household.address.city.total_carbon_saved : nil
  end

  def county_total_carbon_savings
    household ? household.address.county.total_carbon_saved : nil
  end

  def region_total_carbon_savings
    household ? household.address.city.region.total_carbon_saved : nil
  end

  def country_total_carbon_savings
    household ? household.address.city.region.country.total_carbon_saved : nil
  end

end
