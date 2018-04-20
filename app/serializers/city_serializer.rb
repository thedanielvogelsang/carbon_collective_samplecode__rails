class CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :number_of_users_in_city, :region, :country,
                  :total_energy_saved,
                  :avg_total_energy_saved_per_user,
                  :avg_daily_energy_consumed_per_user,
                  :avg_daily_energy_consumed_per_capita


  def total_energy_saved
    object.total_energy_saved.to_s + ' kwhs consumed to date'
  end
  def avg_total_energy_saved_per_user
    object.avg_total_energy_saved_per_user.to_s + ' kwhs electricity saved to date'
  end
  def avg_daily_energy_consumed_per_user
    (object.avg_daily_energy_consumed_per_user).to_s + ' daily kwhs consumed per carbon collective user' if object.avg_daily_energy_consumed_per_user != nil
  end
  def avg_daily_energy_consumed_per_capita
    (object.avg_daily_energy_consumed_per_capita).to_s + ' calculated daily kwhs consumed per capita' if object.avg_daily_energy_consumed_per_capita != nil
  end

  def region
    object.region.name
  end
  def country
    object.region.country.name
  end
  def number_of_users_in_city
    object.users.count
  end
end
