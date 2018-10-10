class GlobalSnapshot < ApplicationRecord
  def self.take_snapshot(globe)
    create(
      avg_user_electricity_consumption: globe.avg_user_electricity_consumption,
      avg_user_water_consumption: globe.avg_user_water_consumption,
      avg_user_gas_consumption: globe.avg_user_gas_consumption,
      avg_user_carbon_consumption: globe.avg_user_carbon_consumption,
    )
  end
end
