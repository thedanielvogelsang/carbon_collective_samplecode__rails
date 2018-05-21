class CityCarbonSerializer < ActiveModel::Serializer
  attributes :id, :name, :region, :country, :total_saved, :avg_daily_consumed_per_user,
                  :metric_sym, :metric_name, :rank, :arrow

    def region
      object.region.name
    end

    def country
      object.region.country.name
    end

    # def number_of_users
    #   object.users.count
    # end

    def total_saved
      object.carbon_ranking.total_carbon_saved.round(2)
    end

    def avg_daily_consumed_per_user
      object.carbon_ranking.avg_daily_carbon_consumed_per_user.round(4)
    end

    def metric_name
      "metric tons CO2"
    end
    def metric_sym
      "co2"
    end
    def rank
      object.carbon_ranking.rank
    end
    def arrow
      object.carbon_ranking.arrow
    end
end
