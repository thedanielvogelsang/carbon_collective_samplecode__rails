module RegionHelper

  def check_abbreviation
    check_state
  end

  def update_data
    update_total_electricity_savings
    update_daily_avg_electricity_savings
    update_daily_avg_electricity_consumption
    update_total_water_savings
    update_daily_avg_water_savings
    update_daily_avg_water_consumption
    update_total_gas_savings
    update_daily_avg_gas_savings
    update_daily_avg_gas_consumption
    self.save
  end

  def update_total_electricity_savings
    energy_saved = self.users.map{|u| u.total_electricity_savings}.flatten
              .reduce(0){|sum, num| sum + num}
    self.total_electricity_saved = energy_saved
  end

  def update_daily_avg_electricity_savings
    energy_savings = self.users.map{|u| u.total_electricity_savings }.flatten
            .reduce(0){|sum, num| sum + num } / self.users.count if self.users.count != 0
    self.avg_total_electricity_saved_per_user = energy_savings
  end

  def update_daily_avg_electricity_consumption
    energy_consumed = self.users.map{|u| u.avg_daily_electricity_consumption }.flatten
            .reduce(0){|sum, num| sum + num} / self.users.count if self.users.count != 0
    self.avg_daily_electricity_consumed_per_user = energy_consumed
  end

  def update_total_water_savings
    water_saved = self.users.map{|u| u.total_water_savings}.flatten
              .reduce(0){|sum, num| sum + num}
    self.total_water_saved = water_saved
  end

  def update_daily_avg_water_savings
    water_savings = self.users.map{|u| u.total_water_savings }.flatten
            .reduce(0){|sum, num| sum + num } / self.users.count if self.users.count != 0
    self.avg_total_water_saved_per_user = water_savings
  end

  def update_daily_avg_water_consumption
    water_consumed = self.users.map{|u| u.avg_daily_water_consumption }.flatten
            .reduce(0){|sum, num| sum + num} / self.users.count if self.users.count != 0
    self.avg_daily_water_consumed_per_user = water_consumed
  end

  def update_total_gas_savings
    gas_saved = self.users.map{|u| u.total_gas_savings}.flatten
              .reduce(0){|sum, num| sum + num}
    self.total_gas_saved = gas_saved
  end

  def update_daily_avg_gas_savings
    gas_savings = self.users.map{|u| u.total_gas_savings }.flatten
            .reduce(0){|sum, num| sum + num } / self.users.count if self.users.count != 0
    self.avg_total_gas_saved_per_user = gas_savings
  end
  
  def update_daily_avg_gas_consumption
    gas_consumed = self.users.map{|u| u.avg_daily_gas_consumption }.flatten
            .reduce(0){|sum, num| sum + num} / self.users.count if self.users.count != 0
    self.avg_daily_gas_consumed_per_user = gas_consumed
  end

  private

  def check_state
    state_abb = self.name
    US_STATES.keys.include?(state_abb) ? self.state = US_STATES[state_abb] : nil
  end

  US_STATES = {
    "AL" => "Alabama",
    "AK" => "Alaska",
    "AZ" => "Arizona",
    "AR" => "Arkansas",
    "CA" => "California",
    "CO" => "Colorado",
    "CT" => "Connecticut",
    "DE" => "Deleware",
    "FL" => "Florida",
    "GA" => "Georgia",
    "HI" => "Hawaii",
    "ID" => "Idaho",
    "IL" => "Illinois",
    "IN" => "Indiana",
    "IA" => "Iowa",
    "KS" => "Kansas",
    "KY" => "Kentucky",
    "LA" => "Louisiana",
    "ME" => "Maine",
    "MD" => "Maryland",
    "MA" => "Massachussets",
    "MI" => "Michigan",
    "MN" => "Minnesota",
    "MS" => "Mississippi",
    "MO" => "Missouri",
    "MT" => "Montana",
    "NE" => "Nebraska",
    "NV" => "Nevada",
    "NH" => "New Hampshire",
    "NJ" => "New Jersey",
    "NM" => "New Mexico",
    "NY" => "New York",
    "NC" => "North Carolina",
    "ND" => "North Dakota",
    "OH" => "Ohio",
    "OK" => "Oklahoma",
    "OR" => "Oregon",
    "PA" => "Pennsylvania",
    "RI" => "Rhode Island",
    "SC" => "South Carolina",
    "SD" => "South Dakota",
    "TN" => "Tennessee",
    "TX" => "Texas",
    "UT" => "Utah",
    "VT" => "Vermont",
    "VA" => "Virginia",
    "WA" => "Washington",
    "WV" => "West Virginia",
    "WI" => "Wisconsin",
    "WY" => "Wyoming",
    "DC" => "District of Columbia"
  }
end
