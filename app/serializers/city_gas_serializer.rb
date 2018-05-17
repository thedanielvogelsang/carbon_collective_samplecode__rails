class CityGasSerializer < ActiveModel::Serializer
  attributes :id, :name, :number_of_users, :region, :country,
                  :total_saved,
                  :avg_total_saved_per_user,
                  :avg_daily_consumed_per_user,
                  :avg_daily_consumed_per_capita,


  def total_saved
    object.total_gas_saved.round(2)
  end
  def avg_total_saved_per_user
    object.avg_total_gas_saved_per_user.round(2)
  end
  def avg_daily_consumed_per_user
    (object.avg_daily_gas_consumed_per_user).round(2) if object.avg_daily_gas_consumed_per_user != nil
  end
  def avg_daily_consumed_per_capita
    (object.avg_daily_gas_consumed_per_capita).round(2) if object.avg_daily_gas_consumed_per_capita != nil
  end

  def region
    object.region.name
  end
  def country
    object.region.country.name
  end
  def number_of_users
    object.users.count
  end
end
