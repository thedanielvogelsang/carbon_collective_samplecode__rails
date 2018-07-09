class CountySnapshot < ApplicationRecord
  belongs_to :county

  def self.take_snapshot(county)
    create(county_id: county.id,
      average_daily_electricity_consumption_per_user: county.avg_daily_electricity_consumed_per_user,
      average_daily_water_consumption_per_user: county.avg_daily_water_consumed_per_user,
      average_daily_gas_consumption_per_user: county.avg_daily_gas_consumed_per_user
      )
  end
end
