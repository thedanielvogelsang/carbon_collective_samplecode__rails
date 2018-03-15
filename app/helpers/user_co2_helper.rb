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
    Address.where
  end
end
