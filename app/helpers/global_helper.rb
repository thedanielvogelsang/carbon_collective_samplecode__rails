module GlobalHelper
  include Co2Helper

  def update_data
    update_total_electricity_savings
    update_total_water_savings
    update_total_carbon_savings
    update_avg_electricity_consumption
    update_avg_water_consumption
    update_avg_heat_consumption
    update_avg_carbon_consumption

    update_snapshots
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

  def update_avg_electricity_consumption
    tec = User.all.map{|u| u.avg_daily_electricity_consumption}.reject(&:zero?)
    num = tec.length
    tec = tec.reduce(0){|s,n| s+n} / num unless num === 0
    self.avg_user_electricity_consumption = tec
  end

  def update_avg_water_consumption
    tws = User.all.map{|u| u.avg_daily_water_consumption}.reject(&:zero?)
    num = tws.length
    tws = tws.reduce(0){|s,n| s+n} / num unless num === 0
    self.avg_user_water_consumption = tws
  end

  def update_avg_heat_consumption
    thc = User.all.map{|u| u.avg_daily_gas_consumption}.reject(&:zero?)
    num = thc.length
    thc = thc.reduce(0){|s,n| s+n} / num unless num === 0
    self.avg_user_gas_consumption = thc
  end
  def update_avg_carbon_consumption
    tcc = User.all.map{|u| u.avg_daily_carbon_consumption}.reject(&:zero?)
    num = tcc.length
    tcc = tcc.reduce(0){|s,n| s+n} / num unless num === 0
    self.avg_user_carbon_consumption = tcc
  end
end
