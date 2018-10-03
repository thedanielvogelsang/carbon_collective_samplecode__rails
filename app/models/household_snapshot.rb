class HouseholdSnapshot < ApplicationRecord
  belongs_to :house

  def self.take_snapshot(house)
    eRank = house.electricity_ranking
    wRank = house.water_ranking
    gRank = house.gas_ranking
    cRank = house.carbon_ranking

    houses = House.joins(:users).distinct
    oo = houses.count

    create(house_id: house.id,
       avg_daily_electricity_consumption_per_user: house.avg_daily_electricity_consumed_per_user,
       avg_daily_water_consumption_per_user: house.avg_daily_water_consumed_per_user,
       avg_daily_gas_consumption_per_user: house.avg_daily_gas_consumed_per_user,
       avg_daily_carbon_consumption_per_user: house.avg_daily_carbon_consumed_per_user,
       total_electricity_consumed: house.total_electricity_consumed,
       total_water_consumed: house.total_water_consumed,
       total_gas_consumed: house.total_gas_consumed,
       total_carbon_consumed: house.total_carbon_consumed,
       electricity_rank: eRank.rank,
       water_rank: wRank.rank,
       gas_rank: gRank.rank,
       carbon_rank: cRank.rank,
       out_of: oo
       electricity_out_of: eRank.out_of,
       gas_out_of: gRank.out_of,
       water_out_of: wRank.out_of,
       carbon_out_of: cRank.out_of,
      )
  end
end
