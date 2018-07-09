class RegionSnapshot < ApplicationRecord
  belongs_to :region

  def self.take_snapshot(region)
    create(region_id: region.id,
      average_daily_electricity_consumption_per_user: region.avg_daily_electricity_consumed_per_user,
      average_daily_water_consumption_per_user: region.avg_daily_water_consumed_per_user,
      average_daily_gas_consumption_per_user: region.avg_daily_gas_consumed_per_user
      )
  end
end
