class NeighborhoodSnapshot < ApplicationRecord
  belongs_to :neighborhood

  def self.take_snapshot(neighborhood)
    create(neighborhood_id: neighborhood.id,
      average_daily_energy_consumption_per_user: neighborhood.avg_daily_energy_consumed_per_user,
      average_total_energy_saved_per_user: neighborhood.avg_total_energy_saved_per_user,
      total_energy_saved: neighborhood.total_energy_saved
      )
  end
end
