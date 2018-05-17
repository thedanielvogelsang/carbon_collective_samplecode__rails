class RegionGasSerializer < ActiveModel::Serializer
  attributes :id, :name, :number_of_users_in_region, :country,
                  :total_gas_saved, :rank, :arrow,
                  :avg_total_gas_saved_per_user,
                  :avg_daily_gas_consumed_per_user,
                  :avg_daily_gas_consumed_per_capita

  def total_gas_saved
    object.total_gas_saved.to_s + ' therms gas saved to date'
  end
  def avg_total_gas_saved_per_user
    object.avg_total_gas_saved_per_user.round(2).to_s +
    ' average total therms gas saved per carbon collective user'
  end
  def avg_daily_gas_consumed_per_user
    (object.avg_daily_gas_consumed_per_user).round(2).to_s +
    ' average daily therms consumed per carbon collective user' if object.avg_daily_gas_consumed_per_user != nil
  end
  def avg_daily_gas_consumed_per_capita
    (object.avg_daily_gas_consumed_per_capita).round(2).to_s +
    ' average daily therms consumed per capita' if object.avg_daily_gas_consumed_per_capita != nil
  end

  def country
    object.country.name
  end
  def number_of_users_in_region
    object.users.count
  end
  def rank
    object.gas_ranking.rank
  end
  def arrow
    object.gas_ranking.arrow
  end
end
