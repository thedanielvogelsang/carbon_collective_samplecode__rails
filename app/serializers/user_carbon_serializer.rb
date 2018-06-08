class UserCarbonSerializer < ActiveModel::Serializer
  attributes :id, :first, :last, :avatar_url, :global_collective_savings,
                  :personal_savings_to_date, :personal_usage_to_date,
                  :arrow, :rank, :last_updated, :avg_daily_footprint,
                  :household, :neighborhood, :city, :county, :region, :country,
                  :household_daily_consumption, :neighborhood_daily_consumption,
                  :city_daily_consumption, :county_daily_consumption, :region_daily_consumption,
                  :country_daily_consumption, :avg_daily_consumption,
                  :metric_sym,

  def avg_daily_footprint
    object.avg_daily_carbon_consumption.to_f.round(2).to_s + " lbs"
  end

  def avg_daily_consumption
    object.avg_daily_carbon_consumption.to_f.round(2).to_s + " lbs"
  end
  def neighborhood
    [object.neighborhood.id, object.neighborhood.name] if object.neighborhood
  end

  def total_daily_footprint
    object.total_pounds_logged.round(2).to_s + " lbs"
  end
  def city
    [object.city.id, object.city.name] if object.city
  end
  def county
    [object.county.id, object.county.name] if object.county
  end
  def region
    [object.region.id, object.region.name] if object.region
  end
  def country
    [object.country.id, object.country.name] if object.country
  end

  def avatar_url
    object.url
  end

  def personal_savings_to_date
    object.total_carbon_savings.to_f.round(2).to_s + " lbs"
  end

  def personal_usage_to_date
    object.total_pounds_logged.to_f.round(2).to_s + " lbs"
  end

  def global_collective_savings
    Global.first.total_carbon_saved.to_f.round(2).to_s + " lbs"
  end

  def household_daily_consumption
    object.household.total_carbon_savings_to_date.round(3) if !object.houses.empty?
  end

  def neighborhood_daily_consumption
    object.neighborhood.carbon_ranking.avg_daily_carbon_consumed_per_user.round(3) if !object.houses.empty?
  end

  def city_daily_consumption
    object.city.carbon_ranking.avg_daily_carbon_consumed_per_user.round(3) if !object.houses.empty?
  end

  def county_daily_consumption
    object.county.carbon_ranking.avg_daily_carbon_consumed_per_user.round(3) if !object.houses.empty?
  end

  def region_daily_consumption
    object.region.carbon_ranking.avg_daily_carbon_consumed_per_user.round(3) if !object.houses.empty?
  end

  def country_daily_consumption
    object.country.carbon_ranking.avg_daily_carbon_consumed_per_user.round(3) if !object.houses.empty?
  end
  def metric_sym
    'lbsCO2'
  end

  def arrow
    ops__ = @instance_options[:region]
    if ops__
      object.user_carbon_rankings
        .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].arrow
    else
      nil
    end
  end

  def rank
    ops__ = @instance_options[:region]
    if ops__
      object.user_carbon_rankings
        .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].rank
    else
      nil
    end
  end

  def last_updated
    ops__ = @instance_options[:region]
    if ops__
    object.user_carbon_rankings
          .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].updated_at
    else
      nil
    end
  end

end
