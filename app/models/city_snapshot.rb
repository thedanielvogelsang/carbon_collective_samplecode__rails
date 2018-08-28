class CitySnapshot < ApplicationRecord
  belongs_to :city

  def self.take_snapshot(city)
    eRank = city.electricity_ranking.rank
    wRank = city.water_ranking.rank
    gRank = city.gas_ranking.rank
    cRank = city.carbon_ranking.rank
    rId = city.region.id
    cities = City.where(region_id: rId).joins(:users).distinct
    max_elect = cities.order(avg_daily_electricity_consumed_per_user: :desc).first.avg_daily_electricity_consumed_per_user
    max_wat = cities.order(avg_daily_water_consumed_per_user: :desc).first.avg_daily_water_consumed_per_user
    max_gas = cities.order(avg_daily_gas_consumed_per_user: :desc).first.avg_daily_gas_consumed_per_user
    max_carb = cities.order(avg_daily_carbon_consumed_per_user: :desc).first.avg_daily_carbon_consumed_per_user
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
