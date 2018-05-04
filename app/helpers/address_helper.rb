module AddressHelper
  def create_or_find_regions_and_associations
    create_and_assign_country
  end

  def address
    self.address_line1 + ', ' + self.city + ', ' + self.country
  end

  private

  def create_and_assign_country
    capitalize_name
    check_name
    country = Country.find_by(name: self.country)
    self.country = country.name
    create_and_assign_region(country)
  end

  def create_and_assign_region(country)
      check_state
      region = Region.where(name: self.state, country_id: country.id).first_or_create
      self.state = region.name
      create_and_assign_city(region)
    end
  end

  def create_and_assign_city(region)
    city = City.where(name: self.city, region_id: region.id).first_or_create
    self.city = city.name
    check_neighborhood(city)
  end

  def check_neighborhood(city)
    self.zipcode ? nil : create_zip
    if self.neighborhood
      (self.neighborhood.name == self.neighborhood_name && self.neighborhood.city_id == city.id) ? nil : create_neighborhood(city)
    else
      create_neighborhood(city)
    end
  end

  def create_neighborhood(city)
    if self.neighborhood_name && self.neighborhood_name != ""
      hood = Neighborhood.where(name: self.neighborhood_name, city_id: city.id).first_or_create
      self.neighborhood_id = hood.id
    else
      hood = Neighborhood.where(name: self.zipcode.zipcode + " Zip Area", city_id: city.id).first_or_create
      self.neighborhood_id = hood.id
    end
  end

  def create_zip
    zip = Zipcode.find_by(zipcode: "0")
    self.zipcode_id = zip.id
  end

  def capitalize_name
    self.country = self.country.split(' ')
    .map{|w| w.downcase == 'of' || w.downcase == 'and' ? lowercase(w) : capitalize(w)}
    .join(' ')
  end

  def lowercase(word)
    word.downcase
  end

  def capitalize(word)
    word.capitalize
  end

  def check_name
    self.country == "Usa" ? self.country = "United States of America" : nil
    self.country == "USA" ? self.country = "United States of America" : nil
    self.country == "United States" ? self.country = "United States of America" : nil
  end

  def check_state
    state_abb = self.region.upcase
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
