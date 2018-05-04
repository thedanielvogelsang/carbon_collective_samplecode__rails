module RegionHelper

  def check_abbreviation
    check_state
  end
  
  def update_data
    update_total_savings
    update_daily_avg_consumption
    update_daily_avg_savings
    self.save
  end

  def update_total_savings
    energy_saved = self.users.map{|u| u.total_electricity_savings}.flatten
              .reduce(0){|sum, num| sum + num}
    self.total_energy_saved = energy_saved
  end

  def update_daily_avg_consumption
    energy_consumed = self.users.map{|u| u.avg_daily_electricity_consumption }.flatten
            .reduce(0){|sum, num| sum + num} / self.users.count if self.users.count != 0
    self.avg_daily_energy_consumed_per_user = energy_consumed
  end

  def update_daily_avg_savings
    energy_savings = self.users.map{|u| u.total_electricity_savings }.flatten
            .reduce(0){|sum, num| sum + num } / self.users.count if self.users.count != 0
    self.avg_total_energy_saved_per_user = energy_savings
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
