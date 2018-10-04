class CountrySnapshot < ApplicationRecord
  belongs_to :country

  def self.take_snapshot(country)
    eRank = country.electricity_ranking
    wRank = country.water_ranking
    gRank = country.gas_ranking
    cRank = country.carbon_ranking

    countries = Country.joins(:users).distinct
    oo = countries.count

    create(country_id: country.id,
       avg_daily_electricity_consumption_per_user: country.avg_daily_electricity_consumed_per_user,
       avg_daily_water_consumption_per_user: country.avg_daily_water_consumed_per_user,
       avg_daily_gas_consumption_per_user: country.avg_daily_gas_consumed_per_user,
       avg_daily_carbon_consumption_per_user: country.avg_daily_carbon_consumed_per_user,
       total_electricity_consumed: country.total_electricity_consumed,
       total_water_consumed: country.total_water_consumed,
       total_gas_consumed: country.total_gas_consumed,
       total_carbon_consumed: country.total_carbon_consumed,
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
