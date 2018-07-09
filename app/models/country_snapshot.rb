class CountrySnapshot < ApplicationRecord
  belongs_to :country

  def self.take_snapshot(country)
    create(country_id: country.id,
      average_daily_electricity_consumption_per_user: country.avg_daily_electricity_consumed_per_user,
      average_daily_water_consumption_per_user: country.avg_daily_water_consumed_per_user,
      average_daily_gas_consumption_per_user: country.avg_daily_gas_consumed_per_user
      )
  end
end
