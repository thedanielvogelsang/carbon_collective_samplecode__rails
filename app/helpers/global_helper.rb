module GlobalHelper
  def update_data
    update_total_electricity_savings
    self.save
  end

  def update_total_electricity_savings
    tes = User.all.map{|u| u.total_electricity_savings}.reduce(0){|s,n| s+n}
    self.total_energy_saved = tes
  end
end
