module GlobalHelper
  def total_to_date
    tot = User.all.map{|u| u.total_electricity_savings_to_date}.reduce(0){|s,n| s+n}
    self.total_electricity_saved = tot
    self.save
  end
end
