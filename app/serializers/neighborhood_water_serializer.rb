class NeighborhoodWaterSerializer < ActiveModel::Serializer
  attributes :id, :name, :number_of_users_in_neighborhood, :city, :region, :country,
                  :total_water_saved,
                  :avg_total_water_saved_per_user,
                  :avg_daily_water_consumed_per_user,
                  :avg_daily_water_consumed_per_capita


  def total_water_saved
    object.total_water_saved.round(2).to_s + ' gallons water saved to date'
  end
  def avg_total_water_saved_per_user
    object.avg_total_water_saved_per_user.round(2).to_s +
    ' average total gallons water saved per carbon collective user'
  end
  def avg_daily_water_consumed_per_user
    (object.avg_daily_water_consumed_per_user).round(2).to_s +
    ' average daily gallons consumed per carbon collective user' if object.avg_daily_water_consumed_per_user != nil
  end
  def avg_daily_water_consumed_per_capita
    (object.avg_daily_water_consumed_per_capita).round(2).to_s +
    ' average daily gallons consumed per capita' if object.avg_daily_water_consumed_per_capita != nil
  end

  def city
    object.city.name
  end
  def region
    object.city.region.name
  end
  def country
    object.city.region.country.name
  end
  def number_of_users_in_neighborhood
    object.users.count
  end
end
