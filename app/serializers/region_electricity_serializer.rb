class RegionElectricitySerializer < ActiveModel::Serializer
  attributes :id, :name, :country,
                  :total_saved, :rank, :arrow,
                  :metric_sym, :metric_name,
                  :avg_daily_consumed_per_user,
                  :avg_daily_consumed_per_capita

  def total_saved
    object.total_electricity_saved
  end
  # def avg_total_saved_per_user
  #   object.avg_total_electricity_saved_per_user.round(2)
  # end
  def avg_daily_consumed_per_user
    (object.avg_daily_electricity_consumed_per_user).round(2) if object.avg_daily_electricity_consumed_per_user != nil
  end
  def avg_daily_consumed_per_capita
    (object.avg_daily_electricity_consumed_per_capita).round(2) if object.avg_daily_electricity_consumed_per_capita != nil
  end
  def country
    object.country.name
  end
  def metric_name
    "kilowatt hours"
  end
  def metric_sym
    "kwhs"
  end
  def rank
    object.electricity_ranking.rank
  end
  def arrow
    object.electricity_ranking.arrow
  end
end
