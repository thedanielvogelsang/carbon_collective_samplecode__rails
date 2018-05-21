module GlobalHelper
  include Co2Helper

  def update_data
    update_total_electricity_savings
    update_total_water_savings
    update_total_carbon_savings
    self.save
  end

  # future iterations will add in gas savings
  #       and convert to uniform metric
  def update_total_electricity_savings
    tes = User.all.map{|u| u.total_electricity_savings}.reduce(0){|s,n| s+n}
    self.total_energy_saved = tes
  end

  def update_total_water_savings
    tws = User.all.map{|u| u.total_water_savings}.reduce(0){|s,n| s+n}
    self.total_water_saved = tws
  end

  def update_total_carbon_savings
    tcs = User.all.map{|u| u.total_carbon_savings}.reduce(0){|s,n| s+n}
    self.total_carbon_saved = tcs
  end
end
