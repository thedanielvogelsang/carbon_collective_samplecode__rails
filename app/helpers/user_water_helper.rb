module UserWaterHelper

  def avg_daily_water_savings
    self.total_gallons_logged / self.total_waterbill_days_logged
  end

  def avg_daily_water_consumption
    self.total_gallons_logged.fdiv(self.total_waterbill_days_logged)
  end

  def household
    self.houses.first if !self.houses.empty?
  end

  def address
    self.houses.empty? ? nil : household.address.address
  end

  def neighborhood
    (!self.houses.empty? && self.houses.first.address.neighborhood) ? household.address.neighborhood : nil
  end

  def city
    self.houses.empty? ? nil : household.address.city
  end

  def region
    self.houses.empty? ? nil : household.address.region
  end

  def country
    self.houses.empty? ? nil : household.address.country
  end
# check
  def household_total_water_savings
    household ? household.total_water_savings_to_date : nil
  end

  def neighborhood_total_water_savings
    household.address.neighborhood ? household.address.neighborhood.total_water_saved : nil
  end

  def city_total_water_savings
    household ? household.address.city.total_water_saved : nil
  end

  def region_total_water_savings
    household ? household.address.city.region.total_water_saved : nil
  end

  def country_total_water_savings
    household ? household.address.city.region.country.total_water_saved : nil
  end

end
