module UserCo2Helper

  def total_co2_update
    # total_household_electricity_savings
    # total_neighborhood_electricity_savings
    # total_city_electricity_savings
    # total_county_electricity_savings
    # total_state_electricity_savings
    # total_country_electricity_savings
  end

  def total_electricity_savings_to_date
    self.bills.map{|b| b.electricity_saved}.reduce(0){|s, n| s + n}
  end

  def total_electricity_consumption_to_date
    self.bills.map{|b| b.total_kwhs}.reduce(0){|s, n| s + n}
  end

  def avg_monthly_electricity_savings
    total_electricity_savings_to_date == 0 ? 0 : total_electricity_savings_to_date / self.bills.count
  end

  def avg_monthly_electricity_consumption
    total_electricity_consumption_to_date == 0 ? 0 : total_electricity_consumption_to_date / self.bills.count
  end

  def household
    self.houses.first if !self.houses.empty?
  end

  def address
    self.houses.empty? ? nil : household.address.address
  end

  def neighborhood
    self.houses.empty? ? nil : address.neighborhood.name
  end

  def city
    self.houses.empty? ? nil : neighborhood.city.name
  end

  def region
    self.houses.empty? ? nil : city.region.name
  end

  def country
    self.houses.empty? ? nil : region.country.name
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
