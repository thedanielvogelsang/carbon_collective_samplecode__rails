class NeighborhoodWaterSerializer < ActiveModel::Serializer
  attributes :id, :name, :number_of_users, :city, :region, :country,
                  :total_saved, :rank, :arrow,
                  :avg_total_saved_per_user,
                  :avg_daily_consumed_per_user,
                  :avg_daily_consumed_per_capita


  def total_saved
    object.total_water_saved.round(2)
  end
  def avg_total_saved_per_user
    object.avg_total_water_saved_per_user.round(2) if object.avg_total_water_saved_per_user != nil
  end
  def avg_daily_consumed_per_user
    (object.avg_daily_water_consumed_per_user).round(2) if object.avg_daily_water_consumed_per_user != nil
  end
  def avg_daily_consumed_per_capita
    (object.avg_daily_water_consumed_per_capita) if object.avg_daily_water_consumed_per_capita != nil
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
  def number_of_users
    object.users.count
  end
  def rank
    object.water_ranking.rank
  end
  def arrow
    object.water_ranking.arrow
  end
end
