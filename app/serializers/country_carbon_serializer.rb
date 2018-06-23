class CountryCarbonSerializer < ActiveModel::Serializer
  attributes :id, :name, :avg_monthly_consumed_per_user,
                  :metric_sym, :metric_name, :rank, :arrow, :out_of

    # def number_of_users
    #   object.users.count
    # end

    # def total_saved
    #   object.carbon_ranking.total_carbon_saved.round(2)
    # end

    def avg_daily_consumed_per_user
      object.carbon_ranking.avg_daily_carbon_consumed_per_user.round(2)
    end
    def avg_monthly_consumed_per_user
      (object.carbon_ranking.avg_daily_carbon_consumed_per_user * 29.53).round(2)
    end

    def metric_name
      "pounds of CO2"
    end
    def metric_sym
      "lbs"
    end
    def rank
      object.carbon_ranking.rank
    end
    def arrow
      object.carbon_ranking.arrow
    end
    def out_of
      Country.count
    end
end
