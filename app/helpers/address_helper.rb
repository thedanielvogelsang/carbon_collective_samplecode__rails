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
    country = Country.find_or_create_by(name: self.country)
    self.country = country.name
    create_and_assign_region(country)
  end

  def create_and_assign_region(country)
    if self.state
      region = Region.where(name: self.state, country_id: country.id).first_or_create
      self.state = region.name
      create_and_assign_city(region)
    else
      region = Region.where(name: self.country + ' Region', country_id: country.id).first_or_create
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
    self.neighborhood ? nil : create_neighborhood(city)
  end

  def create_neighborhood(city)
    if self.neighborhood_name
      hood = Neighborhood.where(name: self.neighborhood_name, city_id: city.id).first_or_create
      self.neighborhood_id = hood.id
    else
      hood = Neighborhood.where(name: self.zipcode.zipcode + " zip area", city_id: city.id).first_or_create
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
end
