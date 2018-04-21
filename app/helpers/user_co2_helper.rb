module UserCo2Helper

  def avg_daily_electricity_savings
    self.total_kwhs_logged / self.total_days_logged
  end

  def avg_daily_electricity_consumption
    self.total_kwhs_logged.fdiv(self.total_days_logged)
  end

  def household
    self.houses.first if !self.houses.empty?
  end

  def address
    self.houses.empty? ? nil : household.address.address
  end

  def neighborhood
    self.houses.empty? ? nil : household.address.neighborhood.name
  end

  def city
    self.houses.empty? ? nil : household.address.neighborhood.city.name
  end

  def region
    self.houses.empty? ? nil : household.address.neighborhood.city.region.name
  end

  def country
    self.houses.empty? ? nil : household.address.neighborhood.city.region.country.name
  end

  def household_total_savings
    household ? household.total_electricity_savings_to_date : nil
  end

  def neighborhood_total_savings
    household ? household.address.neighborhood.total_energy_saved : nil
  end

  def city_total_savings
    household ? household.address.neighborhood.city.total_energy_saved : nil
  end

  def region_total_savings
    household ? household.address.neighborhood.city.region.total_energy_saved : nil
  end

  def country_total_savings
    household ? household.address.neighborhood.city.region.country.total_energy_saved : nil
  end

end
