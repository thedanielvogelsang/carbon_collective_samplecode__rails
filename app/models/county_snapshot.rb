class CountySnapshot < ApplicationRecord
  belongs_to :county

  def self.take_snapshot(county)
    eRank = county.electricity_ranking.rank
    wRank = county.water_ranking.rank
    gRank = county.gas_ranking.rank
    cRank = county.carbon_ranking.rank
    rId = county.region.id
    counties = County.where(region_id: rId).joins(:users).distinct
    oo = counties.count
    if oo > 0
      max_elect = counties.order(avg_daily_electricity_consumed_per_user: :desc).first.avg_daily_electricity_consumed_per_user
      max_wat = counties.order(avg_daily_water_consumed_per_user: :desc).first.avg_daily_water_consumed_per_user
      max_gas = counties.order(avg_daily_gas_consumed_per_user: :desc).first.avg_daily_gas_consumed_per_user
      max_carb = counties.order(avg_daily_carbon_consumed_per_user: :desc).first.avg_daily_carbon_consumed_per_user
    end

    create(county_id: county.id,
       avg_daily_electricity_consumption_per_user: county.avg_daily_electricity_consumed_per_user,
       avg_daily_water_consumption_per_user: county.avg_daily_water_consumed_per_user,
       avg_daily_gas_consumption_per_user: county.avg_daily_gas_consumed_per_user,
       avg_daily_carbon_consumption_per_user: county.avg_daily_carbon_consumed_per_user,
       total_electricity_consumed: county.total_electricity_consumed,
       total_water_consumed: county.total_water_consumed,
       total_gas_consumed: county.total_gas_consumed,
       total_carbon_consumed: county.total_carbon_consumed,
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
