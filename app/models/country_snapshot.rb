class CountrySnapshot < ApplicationRecord
  belongs_to :country

  def self.take_snapshot(country)
    eRank = country.electricity_ranking.rank
    wRank = country.water_ranking.rank
    gRank = country.gas_ranking.rank
    cRank = country.carbon_ranking.rank

    countries = Country.joins(:users).distinct
    max_elect = countries.order(avg_daily_electricity_consumed_per_user: :desc).first
    max_wat = countries.order(avg_daily_water_consumed_per_user: :desc).first
    max_gas = countries.order(avg_daily_gas_consumed_per_user: :desc).first
    max_carb = countries.order(avg_daily_carbon_consumed_per_user: :desc).first
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
