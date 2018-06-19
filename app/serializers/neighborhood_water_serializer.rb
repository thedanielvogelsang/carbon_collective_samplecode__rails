class NeighborhoodWaterSerializer < ActiveModel::Serializer
  attributes :id, :name, :parent,
                  :total_saved, :rank, :arrow,
                  :metric_name, :metric_sym,
                  :avg_daily_consumed_per_user,
                  :avg_daily_consumed_per_capita, :out_of


  def total_saved
    object.total_water_saved.round(2)
  end
  # def avg_total_saved_per_user
  #   object.avg_total_water_saved_per_user.round(2) if object.avg_total_water_saved_per_user != nil
  # end
  def avg_daily_consumed_per_user
    (object.avg_daily_water_consumed_per_user).round(2) if object.avg_daily_water_consumed_per_user != nil
  end
  def avg_daily_consumed_per_capita
    (object.avg_daily_water_consumed_per_capita).round(2) if object.avg_daily_water_consumed_per_capita != nil
  end

  def parent
    object.city.name
  end
  # def region
  #   object.city.region.name
  # end
  # def country
  #   object.city.region.country.name
  # end
  # def number_of_users
  #   object.users.count
  # end
  def rank
    object.water_ranking.rank
  end
  def arrow
    object.water_ranking.arrow
  end
  def metric_name
    "gallons of water"
  end
  def metric_sym
    "gal."
  end
  def out_of
    Neighborhood.where(city: object.city).count
  end
end
