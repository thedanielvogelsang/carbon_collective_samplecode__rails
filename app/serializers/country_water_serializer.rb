class CountryWaterSerializer < ActiveModel::Serializer
  attributes :id, :name, :metric_name, :rank, :arrow,
                  :metric_sym,
                  :avg_monthly_consumed_per_user,
                  :avg_monthly_consumed_per_capita, :out_of

  # def total_saved
  #   object.total_water_saved.round(2)
  # end
  # def avg_total_saved_per_user
  #   object.avg_total_water_saved_per_user.round(2)
  # end
  def avg_daily_consumed_per_user
    (object.avg_daily_water_consumed_per_user).round(2)
  end
  def avg_daily_consumed_per_capita
    (object.avg_daily_water_consumed_per_capita).round(2) if object.avg_daily_water_consumed_per_capita != nil
  end

  def avg_monthly_consumed_per_user
    (object.avg_daily_water_consumed_per_user * 29.53).round(2)
  end

  def avg_monthly_consumed_per_capita
    (object.avg_daily_water_consumed_per_capita * 29.53).round(2) if object.avg_daily_water_consumed_per_capita != nil
  end
  # def number_of_users
  #   object.users.count
  # end
  def metric_name
    "gallons of water"
  end
  def metric_sym
    "gal."
  end
  def rank
    object.water_ranking.rank
  end
  def arrow
    object.water_ranking.arrow
  end
  def out_of
    object.water_ranking.out_of
  end
end
