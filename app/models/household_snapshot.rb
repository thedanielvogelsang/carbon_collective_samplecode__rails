class HouseholdSnapshot < ApplicationRecord
  belongs_to :house

  def self.take_snapshot(house)
    create(house_id: house.id,
      average_daily_energy_consumption_per_resident: house.average_daily_energy_consumption_per_resident,
      average_total_energy_saved_per_resident: house.average_total_energy_saved_per_resident,
      total_energy_saved: house.total_energy_saved
      )
  end
end
