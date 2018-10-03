class NeighborhoodSnapshot < ApplicationRecord
  belongs_to :neighborhood

  def self.take_snapshot(neighborhood)
    eRank = neighborhood.electricity_ranking
    wRank = neighborhood.water_ranking
    gRank = neighborhood.gas_ranking
    cRank = neighborhood.carbon_ranking

    rId = neighborhood.region.id
    hoods = Neighborhood.joins(:users).distinct
    oo = hoods.count

    create(neighborhood_id: neighborhood.id,
        avg_daily_electricity_consumption_per_user: neighborhood.avg_daily_electricity_consumed_per_user,
        avg_daily_water_consumption_per_user: neighborhood.avg_daily_water_consumed_per_user,
        avg_daily_gas_consumption_per_user: neighborhood.avg_daily_gas_consumed_per_user,
        avg_daily_carbon_consumption_per_user: neighborhood.avg_daily_carbon_consumed_per_user,
        total_electricity_consumed: neighborhood.total_electricity_consumed,
        total_water_consumed: neighborhood.total_water_consumed,
        total_gas_consumed: neighborhood.total_gas_consumed,
        total_carbon_consumed: neighborhood.total_carbon_consumed,
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
