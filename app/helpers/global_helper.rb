module GlobalHelper
  def self.total_to_date
    User.all.map{|u| u.total_co2_saved}.reduce(0){|s,n| s+n}
  end
end
