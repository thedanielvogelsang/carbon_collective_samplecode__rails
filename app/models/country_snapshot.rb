class CountrySnapshot < ApplicationRecord
  belongs_to :country

  def self.take_snapshot(country)
    create(country_id: country.id,
      average_daily_energy_consumption_per_user: country.avg_daily_energy_consumed_per_user,
      average_total_energy_saved_per_user: country.avg_total_energy_saved_per_user,
      total_energy_saved: country.total_energy_saved
      )
  end
end
