class CitySnapshot < ApplicationRecord
  belongs_to :city

  def self.take_snapshot(city)
    eRank = city.electricity_ranking
    wRank = city.water_ranking
    gRank = city.gas_ranking
    cRank = city.carbon_ranking

    cities = City.joins(:users).distinct
    oo = cities.count

    create(city_id: city.id,
       avg_daily_electricity_consumption_per_user: city.avg_daily_electricity_consumed_per_user,
       avg_daily_water_consumption_per_user: city.avg_daily_water_consumed_per_user,
       avg_daily_gas_consumption_per_user: city.avg_daily_gas_consumed_per_user,
       avg_daily_carbon_consumption_per_user: city.avg_daily_carbon_consumed_per_user,
       total_electricity_consumed: city.total_electricity_consumed,
       total_water_consumed: city.total_water_consumed,
       total_gas_consumed: city.total_gas_consumed,
       total_carbon_consumed: city.total_carbon_consumed,
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
