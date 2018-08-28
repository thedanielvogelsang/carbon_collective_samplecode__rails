class HouseholdSnapshot < ApplicationRecord
  belongs_to :house

  def self.take_snapshot(house)
    eRank = house.electricity_ranking.rank
    wRank = house.water_ranking.rank
    gRank = house.gas_ranking.rank
    cRank = house.carbon_ranking.rank
    nId = house.neighborhood.id
    houses = House.joins(:address).where(:addresses => {neighborhood_id: nId}).joins(:users).distinct

    oo = houses.count
    max_elect = houses.order(avg_daily_electricity_consumed_per_user: :desc).first.avg_daily_electricity_consumed_per_user
    max_wat = houses.order(avg_daily_water_consumed_per_user: :desc).first.avg_daily_water_consumed_per_user
    max_gas = houses.order(avg_daily_gas_consumed_per_user: :desc).first.avg_daily_gas_consumed_per_user
    max_carb = houses.order(avg_daily_carbon_consumed_per_user: :desc).first.avg_daily_carbon_consumed_per_user

    create(house_id: house.id,
       avg_daily_electricity_consumption_per_user: house.avg_daily_electricity_consumed_per_user,
       avg_daily_water_consumption_per_user: house.avg_daily_water_consumed_per_user,
       avg_daily_gas_consumption_per_user: house.avg_daily_gas_consumed_per_user,
       avg_daily_carbon_consumption_per_user: house.avg_daily_carbon_consumed_per_user,
       total_electricity_consumed: house.total_electricity_consumption_to_date,
       total_water_consumed: house.total_water_consumption_to_date,
       total_gas_consumed: house.total_gas_consumption_to_date,
       total_carbon_consumed: house.total_carbon_consumption_to_date,
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
