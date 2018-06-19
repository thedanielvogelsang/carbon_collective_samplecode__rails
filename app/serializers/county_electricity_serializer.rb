class CountyElectricitySerializer < ActiveModel::Serializer
  attributes :id, :name, :metric_name,
                  :rank, :arrow,
                  :metric_sym, :total_saved,
                  :avg_daily_consumed_per_user,
                  :avg_daily_consumed_per_capita, :out_of

  def total_saved
    object.total_electricity_saved.round(2)
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
  # def number_of_users
  #   object.users.count
  # end
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
  def out_of
    County.where(region: object.region).count
  end
end
