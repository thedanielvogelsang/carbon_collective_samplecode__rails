module GroupCo2Helper
  def group_collective_savings
    self.users.map{|u| u.total_co2_saved.to_f}.reduce(0){|s,n| s + n}
  end
end
