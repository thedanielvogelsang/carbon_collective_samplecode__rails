module UserCo2Helper

  def total_co2_update
    total_household_energy_savings
    total_neighborhood_energy_savings
    total_city_energy_savings
    total_county_energy_savings
    total_state_energy_savings
    total_country_energy_savings
  end
  
  def total_co2_saved
    self.bills.map{|b| b.carbon_saved.to_f}.reduce(0){|sum, num| sum + num}
  end

  def total_household_energy_cost
    self.bills.map{|b| b.price.to_f}.reduce(0){|sum, num| sum + num }
  end

  def total_household_energy_savings
    savings = self.bills.map{|b| b.carbon_saved.to_f}.reduce(0){|sum, num| sum + num}
    self.household = savings
    self.save
  end

  def total_neighborhood_energy_savings
    my_zips = self.addresses.map{|a| a.zipcode_id}
    my_neighbors = my_zips.map do |zip_id|
      User.joins(:addresses).where(:addresses => {zipcode: zip_id})
    end
    self.neighborhood = my_neighbors.flatten.map{|n| n.total_co2_saved}
                                                .reduce(0){|s,n| s+n}
    self.save
  end

  def total_city_energy_savings
    my_cities = self.addresses.map{|a| a.city}
    city_members = my_cities.map do |city|
      User.joins(:addresses).where(:addresses => {city: city})
    end
    self.city = city_members.flatten.map{|n| n.total_co2_saved}
                                                .reduce(0){|s,n| s+n}
    self.save
  end

  def total_county_energy_savings
    my_counties = self.addresses.map{|a| a.county}
    county_members = my_counties.map do |county|
      User.joins(:addresses).where(:addresses => {county: county})
    end
    self.county = county_members.flatten.map{|n| n.total_co2_saved}
                                                .reduce(0){|s,n| s+n}
    self.save
  end

  def total_state_energy_savings
    my_states = self.addresses.map{|a| a.state}
    state_members = my_states.map do |state|
      User.joins(:addresses).where(:addresses => {state: state})
    end
    self.state_or_province = state_members.flatten.map{|n| n.total_co2_saved}
                                                .reduce(0){|s,n| s+n}
    self.save
  end

  def total_country_energy_savings
    my_countries = self.addresses.map{|a| a.country}
    country_members = my_countries.map do |country|
      User.joins(:addresses).where(:addresses => {country: country})
    end
    self.country = country_members.flatten.map{|n| n.total_co2_saved}
                                                .reduce(0){|s,n| s+n}
    self.save
  end
end
