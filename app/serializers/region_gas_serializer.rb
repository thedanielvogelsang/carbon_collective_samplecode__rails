class RegionGasSerializer < ActiveModel::Serializer
  attributes :id, :name, :parent,
                  :total_saved, :rank, :arrow,
                  :metric_name, :metric_sym,
                  :avg_daily_consumed_per_user,
                  :avg_daily_consumed_per_capita, :out_of

  def total_saved
    object.total_gas_saved
  end
  # def avg_total_saved_per_user
  #   object.avg_total_gas_saved_per_user.round(2)
  # end
  def avg_daily_consumed_per_user
    (object.avg_daily_gas_consumed_per_user).round(2) if object.avg_daily_gas_consumed_per_user != nil
  end
  def avg_daily_consumed_per_capita
    (object.avg_daily_gas_consumed_per_capita).round(2) if object.avg_daily_gas_consumed_per_capita != nil
  end

  def parent
    object.country.name
  end
  def number_of_users_in_region
    object.users.count
  end
  def rank
    object.gas_ranking.rank
  end
  def arrow
    object.gas_ranking.arrow
  end
  def metric_name
    "thermal heat units"
  end
  def metric_sym
    "therms"
  end
  def out_of
    Region.where(country: object.country).count
  end
end
