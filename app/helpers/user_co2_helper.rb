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
    household ? household.address.neighborhood.total_electricity_savings_to_date : nil
  end

  def city_total_savings
    household ? household.address.neighborhood.city.total_electricity_savings_to_date : nil
  end

  def region_total_savings
    household ? household.address.neighborhood.city.region.total_electricity_savings_to_date : nil
  end

  def country_total_savings
    household ? household.address.neighborhood.city.region.country.total_electricity_savings_to_date : nil
  end


  # def total_city_electricity_savings
  #   my_cities = self.addresses.map{|a| a.city}
  #   city_members = my_cities.map do |city|
  #     User.joins(:addresses).where(:addresses => {city: city})
  #   end
  #   self.city = city_members.flatten.map{|n| n.total_co2_saved}
  #                                               .reduce(0){|s,n| s+n}
  #   self.save
  # end
  #
  # def total_county_electricity_savings
  #   my_counties = self.addresses.map{|a| a.county}
  #   county_members = my_counties.map do |county|
  #     User.joins(:addresses).where(:addresses => {county: county})
  #   end
  #   self.county = county_members.flatten.map{|n| n.total_co2_saved}
  #                                               .reduce(0){|s,n| s+n}
  #   self.save
  # end
  #
  # def total_state_electricity_savings
  #   my_states = self.addresses.map{|a| a.state}
  #   state_members = my_states.map do |state|
  #     User.joins(:addresses).where(:addresses => {state: state})
  #   end
  #   self.state_or_province = state_members.flatten.map{|n| n.total_co2_saved}
  #                                               .reduce(0){|s,n| s+n}
  #   self.save
  # end
  #
  # def total_country_electricity_savings
  #   my_countries = self.addresses.map{|a| a.country}
  #   country_members = my_countries.map do |country|
  #     User.joins(:addresses).where(:addresses => {country: country})
  #   end
  #   self.country = country_members.flatten.map{|n| n.total_co2_saved}
  #                                               .reduce(0){|s,n| s+n}
  #   self.save
  # end
end
