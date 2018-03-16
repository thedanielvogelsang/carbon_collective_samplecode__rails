module UserCo2Helper

  def total_co2_saved
    self.bills.map{|b| b.carbon_saved.to_f}.reduce(0){|sum, num| sum + num}
  end

  def total_household_energy_cost
    self.bills.map{|b| b.price.to_f}.reduce(0){|sum, num| sum + num }
  end

  def total_household_energy_savings
    self.bills.map{|b| b.carbon_saved.to_f}.reduce(0){|sum, num| sum + num}
  end

  def total_neighborhood_energy_savings
    my_zips = self.addresses.map{|a| a.zipcode_id}
    my_neighbors = my_zips.map do |zip_id|
      User.joins(:addresses).where(:addresses => {zipcode: zip_id})
    end
    # self.total_neighborhood_energy_savings ||= my_neighbors.flatten.map{|n| n.total_co2_saved}
    #                                               .reduce(0){|s,n| s+n}
  end

  
end
