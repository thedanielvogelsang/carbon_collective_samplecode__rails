class RegionSnapshot < ApplicationRecord
  belongs_to :region
  
  def self.take_snapshot(region)
    create(region_id: region.id,
      average_daily_energy_consumption_per_user: region.avg_daily_energy_consumed_per_user,
      average_total_energy_saved_per_user: region.avg_total_energy_saved_per_user,
      total_energy_saved: region.total_energy_saved
      )
  end
end
