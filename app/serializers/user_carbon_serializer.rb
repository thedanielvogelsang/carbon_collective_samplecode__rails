class UserCarbonSerializer < ActiveModel::Serializer

  attributes :id, :first, :last, :avatar_url, :privacy_policy,
                  :personal_savings_to_date, :personal_usage_to_date,
                  :arrow, :rank, :last_updated, :avg_daily_footprint, :avg_monthly_footprint,
                  :household, :neighborhood, :city, :county, :region, :country,
                  :household_monthly_consumption, :neighborhood_monthly_consumption,
                  :city_monthly_consumption, :county_monthly_consumption, :region_monthly_consumption,
                  :country_monthly_consumption, :avg_daily_consumption, :avg_monthly_consumption,
                  :metric_sym, :out_of

  def avg_daily_footprint
    object.avg_daily_carbon_consumption.to_f.round(2).to_s + " lbs" if object.avg_daily_carbon_consumption
  end

  def avg_daily_consumption
    object.avg_daily_carbon_consumption.to_f.round(2).to_s + " lbs" if object.avg_daily_carbon_consumption
  end

  def avg_monthly_footprint
    (object.avg_daily_carbon_consumption * 29.53).to_f.round(2).to_s + " lbs" if object.avg_daily_carbon_consumption
  end

  def avg_monthly_consumption
    (object.avg_daily_carbon_consumption * 29.53).to_f.round(2).to_s + " lbs" if object.avg_daily_carbon_consumption
  end
  def neighborhood
    [object.neighborhood.id, object.neighborhood.name, object.neighborhood.carbon_ranking.rank, object.neighborhood.out_of] if object.neighborhood
  end

  def total_daily_footprint
    object.total_pounds_logged.round(2).to_s + " lbs"
  end
  def city
    [object.city.id, object.city.name, object.city.carbon_ranking.rank, object.city.out_of] if object.city
  end
  def county
    [object.county.id, object.county.name, object.county.carbon_ranking.rank, object.county.out_of] if object.county
  end
  def region
    [object.region.id, object.region.name, object.region.carbon_ranking.rank, object.region.out_of] if object.region
  end
  def country
    [object.country.id, object.country.name, object.country.carbon_ranking.rank, object.country.out_of] if object.country
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

  # def global_collective_savings
  #   Global.first.total_carbon_saved.to_f.round(2).to_s + " lbs"
  # end

  def household_daily_consumption
    object.household.total_carbon_savings_to_date.round(2) if !object.houses.empty?
  end

  def neighborhood_daily_consumption
    object.neighborhood.carbon_ranking.avg_daily_carbon_consumed_per_user.round(2) if !object.houses.empty?
  end

  def city_daily_consumption
    object.city.carbon_ranking.avg_daily_carbon_consumed_per_user.round(2) if !object.houses.empty?
  end

  def county_daily_consumption
    object.county.carbon_ranking.avg_daily_carbon_consumed_per_user.round(2) if !object.houses.empty?
  end

  def region_daily_consumption
    object.region.carbon_ranking.avg_daily_carbon_consumed_per_user.round(3) if !object.houses.empty?
  end

  def country_daily_consumption
    object.country.carbon_ranking.avg_daily_carbon_consumed_per_user.round(3) if !object.houses.empty?
  end
  def household_monthly_consumption
    (object.household.total_carbon_savings_to_date * 29.53).round(2) if !object.houses.empty?
  end

  def neighborhood_monthly_consumption
    (object.neighborhood.carbon_ranking.avg_daily_carbon_consumed_per_user * 29.53).round(2) if !object.houses.empty?
  end

  def city_monthly_consumption
    (object.city.carbon_ranking.avg_daily_carbon_consumed_per_user * 29.53).round(2) if !object.houses.empty?
  end

  def county_monthly_consumption
    (object.county.carbon_ranking.avg_daily_carbon_consumed_per_user * 29.53).round(2) if !object.houses.empty?
  end

  def region_monthly_consumption
    (object.region.carbon_ranking.avg_daily_carbon_consumed_per_user * 29.53).round(2) if !object.houses.empty?
  end

  def country_monthly_consumption
    (object.country.carbon_ranking.avg_daily_carbon_consumed_per_user * 29.53).round(2) if !object.houses.empty?
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

  def out_of
    ops_ = @instance_options[:region] if @instance_options[:region]
    if ops_
      if ops_[:area_type] == "County"
        c = County.find(ops_[:area_id])
        County.where(region: c.region).count
      elsif ops_[:area_type] == "Neighborhood"
        n = Neighborhood.find(ops_[:area_type])
        Neighborhood.where(city: n.city).count
      elsif ops_[:area_type] == "City"
        c = City.find(ops_[:area_id])
        City.where(region: c.region).count
      elsif ops_[:area_type] == "Region"
        r = Region.find(ops_[:area_id])
        Region.where(country: r.country).count
      elsif ops_[:area_type] == "Country"
        Country.count
      end
    else
      nil
    end
  end

end
