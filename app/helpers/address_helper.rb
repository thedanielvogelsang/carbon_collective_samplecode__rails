module AddressHelper

  def address
    self.address_line1 + ', ' + self.city.name + ', ' + self.region.name + ', ' + self.zipcode.zipcode + " " + self.country.name
  end

  def check_ids
    if [false, nil, 'null', 'undefined', 0].include?(self.neighborhood_id)
      self.neighborhood_id = nil
    end
  end

end
