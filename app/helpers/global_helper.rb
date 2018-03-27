module GlobalHelper
  def self.total_to_date
    User.all.map{|u| u.total_electricty_savings_to_date}.reduce(0){|s,n| s+n}
  end
end
