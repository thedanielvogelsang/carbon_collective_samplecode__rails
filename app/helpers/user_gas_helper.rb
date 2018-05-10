module UserGasHelper

  def avg_daily_gas_savings
    self.total_therms_logged / self.total_heatbill_days_logged
  end

  def avg_daily_gas_consumption
    self.total_therms_logged.fdiv(self.total_heatbill_days_logged)
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
  def household_total_gas_savings
    household ? household.total_gas_savings_to_date : nil
  end

  def neighborhood_total_gas_savings
    household.address.neighborhood ? household.address.neighborhood.total_gas_saved : nil
  end

  def city_total_gas_savings
    household ? household.address.city.total_gas_saved : nil
  end

  def region_total_gas_savings
    household ? household.address.city.region.total_gas_saved : nil
  end

  def country_total_gas_savings
    household ? household.address.city.region.country.total_gas_saved : nil
  end

end
