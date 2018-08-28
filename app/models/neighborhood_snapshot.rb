class NeighborhoodSnapshot < ApplicationRecord
  belongs_to :neighborhood

  def self.take_snapshot(neighborhood)
    eRank = neighborhood.electricity_ranking.rank
    wRank = neighborhood.water_ranking.rank
    gRank = neighborhood.gas_ranking.rank
    cRank = neighborhood.carbon_ranking.rank
    cId = neighborhood.city.id
    neighborhoods = Neighborhood.where(city_id: cId).joins(:users).distinct
    oo = neighborhoods.count
    if oo > 0
      max_elect = neighborhoods.order(avg_daily_electricity_consumed_per_user: :desc).first.avg_daily_electricity_consumed_per_user
      max_wat = neighborhoods.order(avg_daily_water_consumed_per_user: :desc).first.avg_daily_water_consumed_per_user
      max_gas = neighborhoods.order(avg_daily_gas_consumed_per_user: :desc).first.avg_daily_gas_consumed_per_user
      max_carb = neighborhoods.order(avg_daily_carbon_consumed_per_user: :desc).first.avg_daily_carbon_consumed_per_user
    end

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
