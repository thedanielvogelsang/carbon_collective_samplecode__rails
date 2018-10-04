class RegionSnapshot < ApplicationRecord
  belongs_to :region

  def self.take_snapshot(region)
    eRank = region.electricity_ranking
    wRank = region.water_ranking
    gRank = region.gas_ranking
    cRank = region.carbon_ranking

    regions = Region.joins(:users).distinct
    oo = regions.count

    create(region_id: region.id,
        avg_daily_electricity_consumption_per_user: region.avg_daily_electricity_consumed_per_user,
        avg_daily_water_consumption_per_user: region.avg_daily_water_consumed_per_user,
        avg_daily_gas_consumption_per_user: region.avg_daily_gas_consumed_per_user,
        avg_daily_carbon_consumption_per_user: region.avg_daily_carbon_consumed_per_user,
        total_electricity_consumed: region.total_electricity_consumed,
        total_water_consumed: region.total_water_consumed,
        total_gas_consumed: region.total_gas_consumed,
        total_carbon_consumed: region.total_carbon_consumed,
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
