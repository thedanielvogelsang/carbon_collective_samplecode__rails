module AddressHelper

  def address
    self.address_line1 + ', ' + self.city.name + ', ' + self.region.name + ', ' + self.zipcode.zipcode + " " + self.country.name
  end

end
