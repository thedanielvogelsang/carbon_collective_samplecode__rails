class RegionElectricitySerializer < ActiveModel::Serializer
  attributes :id, :name, :number_of_users_in_region, :country,
                  :total_electricity_saved,
                  :avg_total_electricity_saved_per_user,
                  :avg_daily_electricity_consumed_per_user,
                  :avg_daily_electricity_consumed_per_capita

  def total_electricity_saved
    object.total_electricity_saved.to_s + ' kwhs electricity saved to date'
  end
  def avg_total_electricity_saved_per_user
    object.avg_total_electricity_saved_per_user.round(2).to_s +
    ' average total kwhs electricity saved per carbon collective user'
  end
  def avg_daily_electricity_consumed_per_user
    (object.avg_daily_electricity_consumed_per_user).round(2).to_s +
    ' average daily kwhs consumed per carbon collective user' if object.avg_daily_electricity_consumed_per_user != nil
  end
  def avg_daily_electricity_consumed_per_capita
    (object.avg_daily_electricity_consumed_per_capita).round(2).to_s +
    ' average daily kwhs consumed per capita' if object.avg_daily_electricity_consumed_per_capita != nil
  end

  def country
    object.country.name
  end
  def number_of_users_in_region
    object.users.count
  end
end
