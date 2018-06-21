class RegionWaterSerializer < ActiveModel::Serializer
  attributes :id, :name, :parent,
                  :rank, :arrow,
                  :metric_name, :metric_sym,
                  :avg_monthly_consumed_per_user,
                  :avg_monthly_consumed_per_capita, :out_of

  # def total_saved
  #   object.total_water_saved
  # end
  # def avg_total_saved_per_user
  #   object.avg_total_water_saved_per_user.round(2)
  # end
  def avg_daily_consumed_per_user
    (object.avg_daily_water_consumed_per_user).round(2) if object.avg_daily_water_consumed_per_user != nil
  end
  def avg_daily_consumed_per_capita
    (object.avg_daily_water_consumed_per_capita) if object.avg_daily_water_consumed_per_capita != nil
  end
  def avg_monthly_consumed_per_user
    (object.avg_daily_water_consumed_per_user * 29.53).round(2) if object.avg_daily_water_consumed_per_user != nil
  end
  def avg_monthly_consumed_per_capita
    (object.avg_daily_water_consumed_per_capita * 29.53) if object.avg_daily_water_consumed_per_capita != nil
  end

  def parent
    object.country.name
  end
  def number_of_users_in_region
    object.users.count
  end
  def rank
    object.water_ranking.rank
  end
  def out_of

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
    Region.where(country: object.country).count
  end
end
