module AddressHelper
  def create_or_find_regions_and_associations
    create_and_assign_country
  end

  private

  def create_and_assign_country
    country = Country.find_or_create_by(name: self.country)
    self.country = country.name
    create_and_assign_region(country)
  end

  def create_and_assign_region(country)
    region = Region.find_or_create_by(name: self.state, country_id: country.id)
    self.state = region.name
    create_and_assign_city(region)
  end

  def create_and_assign_city(region)
    city = City.find_or_create_by(name: self.city, region_id: region.id)
    self.state = city.name
    check_neighborhood(city)
  end

  def check_neighborhood(city)
    self.neighborhood_id == nil ? create_neighborhood(city) : nil
  end

  def create_neighborhood(city)
    nhood = Neighborhood.find_or_create_by(name: self.zipcode.zipcode.to_s, city_id: city.id)
    self.neighborhood_id = nhood.id
  end
end
