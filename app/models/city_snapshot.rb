class CitySnapshot < ApplicationRecord
  belongs_to :city

  def self.take_snapshot(city)
    create(city_id: city.id,
      average_daily_electricity_consumption_per_user: city.avg_daily_electricity_consumed_per_user,
      average_daily_water_consumption_per_user: city.avg_daily_water_consumed_per_user,
      average_daily_gas_consumption_per_user: city.avg_daily_gas_consumed_per_user
      )
  end
end
