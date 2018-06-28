module UserCarbonHelper
  include UserHelper
  include Co2Helper

  # def avg_daily_carbon_savings
  #   user_date = account_length_time
  #   self.total_pounds_logged / user_date.to_i
  # end

  # big question marks around this method
  def avg_daily_carbon_consumption
    res_ = combine_average_use(self.avg_daily_electricity_consumption, self.avg_daily_gas_consumption)
    return res_.fdiv(self.total_electricitybill_days_logged) if res_ != 0
  end

# check
  def household_daily_carbon_consumption
    household ? household.average_daily_carbon_consumption_per_user : nil
  end

  def neighborhood_daily_carbon_consumption
    household.address.neighborhood ? household.address.neighborhood.avg_daily_carbon_consumption : nil
  end

  def city_daily_carbon_consumption
    household ? household.address.city.avg_daily_carbon_consumption : nil
  end

  def county_daily_carbon_consumption
    household ? household.address.county.avg_daily_carbon_consumption : nil
  end

  def region_daily_carbon_consumption
    household ? household.address.city.region.avg_daily_carbon_consumption : nil
  end

  def country_daily_carbon_consumption
    household ? household.address.city.region.country.avg_daily_carbon_consumption : nil
  end

end
