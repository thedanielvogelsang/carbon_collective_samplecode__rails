class UserCarbonSerializer < ActiveModel::Serializer
  attributes :id, :first, :last, :avatar_url, :global_collective_savings,
                  :personal_savings_to_date, :arrow, :rank, :last_updated,
                  :household, :neighborhood, :city, :county, :region, :country,
                  :household_daily_consumption, :neighborhood_daily_consumption,
                  :city_daily_consumption, :county_daily_consumption, :region_daily_consumption,
                  :country_daily_consumption, :avg_daily_consumption,
                  :metric_sym,

  def avg_daily_consumption
    object.total_carbon_savings.to_f.round(2).to_s + " lbs"
  end
  def neighborhood
    [object.neighborhood.id, object.neighborhood.name] if object.neighborhood
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
    object.user_carbon_rankings
      .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].arrow
  end

  def rank
    ops__ = @instance_options[:region]
    object.user_carbon_rankings
      .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].rank
  end

  def last_updated
    ops__ = @instance_options[:region]
    object.user_carbon_rankings
          .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].updated_at
  end

end
