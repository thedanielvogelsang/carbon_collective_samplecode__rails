module UserWaterHelper
  include UserHelper
  #
  # def avg_daily_water_savings
  #   self.total_gallons_logged / self.total_waterbill_days_logged
  # end

  def avg_daily_water_consumption
    self.total_gallons_logged.fdiv(self.total_waterbill_days_logged)
  end

# check
  def household_daily_water_consumption
    household ? household.average_daily_water_consumption_per_resident : nil
  end

  def neighborhood_daily_water_consumption
    household.address.neighborhood ? household.address.neighborhood.avg_daily_water_consumed_per_user : nil
  end

  def city_daily_water_consumption
    household ? household.address.city.avg_daily_water_consumed_per_user : nil
  end

  def county_daily_water_consumption
    household ? household.address.county.avg_daily_water_consumed_per_user : nil
  end

  def region_daily_water_consumption
    household ? household.address.city.region.avg_daily_water_consumed_per_user : nil
  end

  def country_daily_water_consumption
    household ? household.address.city.region.country.avg_daily_water_consumed_per_user : nil
  end
end
