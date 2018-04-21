class CitySnapshot < ApplicationRecord
  belongs_to :city
  
  def self.take_snapshot(city)
    create(city_id: city.id,
      average_daily_energy_consumption_per_user: city.avg_daily_energy_consumed_per_user,
      average_total_energy_saved_per_user: city.avg_total_energy_saved_per_user,
      total_energy_saved: city.total_energy_saved
      )
  end
end
