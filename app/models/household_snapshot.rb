class HouseholdSnapshot < ApplicationRecord
  belongs_to :house

  def self.take_snapshot(house)
    eRank = house.electricity_ranking.rank
    wRank = house.water_ranking.rank
    gRank = house.gas_ranking.rank
    cRank = house.carbon_ranking.rank
    nId = house.neighborhood.id
    houses = House.where(neighborhood_id: nId).joins(:users).distinct
    max_elect = houses.order(avg_daily_electricity_consumed_per_user: :desc).first
    max_wat = houses.order(avg_daily_water_consumed_per_user: :desc).first
    max_gas = houses.order(avg_daily_gas_consumed_per_user: :desc).first
    max_carb = houses.order(avg_daily_carbon_consumed_per_user: :desc).first
    oo = neighborhoods.count

    create(neighborhood_id: neighborhood.id,
       avg_daily_electricity_consumption_per_user: neighborhood.avg_daily_electricity_consumed_per_user,
       avg_daily_water_consumption_per_user: neighborhood.avg_daily_water_consumed_per_user,
       avg_daily_gas_consumption_per_user: neighborhood.avg_daily_gas_consumed_per_user,
       avg_daily_carbon_consumption_per_user: neighborhood.avg_daily_carbon_consumed_per_user,
       total_electricity_consumed: neighborhood.total_electricity_consumed,
       total_water_consumed: neighborhood.total_water_consumed,
       total_gas_consumed: neighborhood.total_gas_consumed,
       total_carbon_consumed: neighborhood.total_carbon_consumed,
       max_daily_electricity_consumption: max_elect,
       max_daily_water_consumption: max_wat,
       max_daily_gas_consumption: max_gas,
       max_daily_carbon_consumption: max_carb,
       electricity_rank: eRank,
       water_rank: wRank,
       gas_rank: gRank,
       carbon_rank: cRank,
       out_of: oo
      )
  end
end
