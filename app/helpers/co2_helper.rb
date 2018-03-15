module Co2Helper
  def total_co2_saved
    
  end

  def total_household_energy_cost
    self.bills.map{|b| b.price.to_f}.reduce(0){|sum, num| sum + num }
  end
end
