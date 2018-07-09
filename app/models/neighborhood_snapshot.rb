class NeighborhoodSnapshot < ApplicationRecord
  belongs_to :neighborhood

  def self.take_snapshot(neighborhood)
    create(neighborhood_id: neighborhood.id,
      average_daily_electricity_consumption_per_user: neighborhood.avg_daily_electricity_consumed_per_user,
      average_daily_water_consumption_per_user: neighborhood.avg_daily_water_consumed_per_user,
      average_daily_gas_consumption_per_user: neighborhood.avg_daily_gas_consumed_per_user
      )
  end
end
