class RegionSnapshot < ApplicationRecord
  belongs_to :region

  def self.take_snapshot(region)
    eRank = region.electricity_ranking.rank
    wRank = region.water_ranking.rank
    gRank = region.gas_ranking.rank
    cRank = region.carbon_ranking.rank
    cId = region.country.id
    regions = Region.where(country_id: cId).joins(:users).distinct
    oo = regions.count
    if oo > 0
      max_elect = regions.order(avg_daily_electricity_consumed_per_user: :desc).first.avg_daily_electricity_consumed_per_user
      max_wat = regions.order(avg_daily_water_consumed_per_user: :desc).first.avg_daily_water_consumed_per_user
      max_gas = regions.order(avg_daily_gas_consumed_per_user: :desc).first.avg_daily_gas_consumed_per_user
      max_carb = regions.order(avg_daily_carbon_consumed_per_user: :desc).first.avg_daily_carbon_consumed_per_user
    end
    create(region_id: region.id,
       avg_daily_electricity_consumption_per_user: region.avg_daily_electricity_consumed_per_user,
       avg_daily_water_consumption_per_user: region.avg_daily_water_consumed_per_user,
       avg_daily_gas_consumption_per_user: region.avg_daily_gas_consumed_per_user,
       avg_daily_carbon_consumption_per_user: region.avg_daily_carbon_consumed_per_user,
       total_electricity_consumed: region.total_electricity_consumed,
       total_water_consumed: region.total_water_consumed,
       total_gas_consumed: region.total_gas_consumed,
       total_carbon_consumed: region.total_carbon_consumed,
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
