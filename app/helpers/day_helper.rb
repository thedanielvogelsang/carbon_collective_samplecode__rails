module DayHelper
  def total_miles_biked
    self.trips.select{|t| t.neutral?}.map{|t| t.total_mileage }.sum()
  end

  def total_miles_driven
    self.trips.select{|t| !t.neutral? }.map{|t| t.total_mileage}.sum()
  end

  def co2_saved
    33.45 - total_co2_used_today
  end

  def total_co2_used_today
    self.trips.map{|t| t.co2_produced }.reduce(0){|sum, num| sum + num }
  end

  def total_daily_mileage
    self.trips.map{|t| t.total_mileage}.sum()
  end
end
