class CountySnapshot < ApplicationRecord
  belongs_to :county

  def self.take_snapshot(county)
    eRank = county.electricity_ranking
    wRank = county.water_ranking
    gRank = county.gas_ranking
    cRank = county.carbon_ranking

    counties = County.joins(:users).distinct
    oo = counties.count

    create(county_id: county.id,
       avg_daily_electricity_consumption_per_user: county.avg_daily_electricity_consumed_per_user,
       avg_daily_water_consumption_per_user: county.avg_daily_water_consumed_per_user,
       avg_daily_gas_consumption_per_user: county.avg_daily_gas_consumed_per_user,
       avg_daily_carbon_consumption_per_user: county.avg_daily_carbon_consumed_per_user,
       total_electricity_consumed: county.total_electricity_consumed,
       total_water_consumed: county.total_water_consumed,
       total_gas_consumed: county.total_gas_consumed,
       total_carbon_consumed: county.total_carbon_consumed,
       electricity_rank: eRank.rank,
       water_rank: wRank.rank,
       gas_rank: gRank.rank,
       carbon_rank: cRank.rank,
       out_of: oo,
       electricity_out_of: eRank.out_of,
       gas_out_of: gRank.out_of,
       water_out_of: wRank.out_of,
       carbon_out_of: cRank.out_of,
      )
  end
end
