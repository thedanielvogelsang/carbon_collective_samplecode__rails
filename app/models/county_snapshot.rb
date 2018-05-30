class CountySnapshot < ApplicationRecord
  belongs_to :county

  def self.take_snapshot(county)
    create(county_id: county.id,
      average_daily_energy_consumption_per_user: county.avg_daily_energy_consumed_per_user,
      average_total_energy_saved_per_user: county.avg_total_energy_saved_per_user,
      total_energy_saved: county.total_energy_saved
      )
  end
end
