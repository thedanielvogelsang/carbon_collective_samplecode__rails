class HouseholdSnapshot < ApplicationRecord
  belongs_to :house

  def self.take_snapshot(house)
    create(house_id: house.id,
      average_daily_electricity_consumption_per_user: house.average_daily_electricity_consumption_per_user,
      average_daily_water_consumption_per_user: house.average_daily_water_consumption_per_user,
      average_daily_gas_consumption_per_user: house.average_daily_gas_consumption_per_user
      )
  end
end
