class UserCarbonSerializer < ActiveModel::Serializer

  attributes :id, :first, :last, :avatar_url, :privacy_policy,
                  :personal_savings_to_date, :personal_usage_to_date,
                  :arrow, :rank, :last_updated, :avg_daily_footprint, :avg_monthly_footprint,
                  :household, :neighborhood, :city, :county, :region, :country,
                  :avg_daily_consumption, :avg_monthly_consumption, :personal,
                  :metric_sym, :out_of, :house, :house_max, :move_in_date, :invite_max, :slug

  def house
    object.household
  end

  def house_max
    object.household.house_max("carbon") if object.household
  end

  def avg_daily_footprint
    object.avg_daily_carbon_consumption.to_f.round(2).to_s if object.avg_daily_carbon_consumption
    "0" if !object.avg_daily_carbon_consumption
  end

  def avg_daily_consumption
    object.avg_daily_carbon_consumption.to_f.round(2).to_s if object.avg_daily_carbon_consumption
  end

  def avg_monthly_footprint
    (object.avg_daily_carbon_consumption * 29.53).to_f.round(2).to_s if object.avg_daily_carbon_consumption
  end

  def avg_monthly_consumption
    object.avg_daily_carbon_consumption ? (object.avg_daily_carbon_consumption * 29.53).to_f.round(2).to_s : "0"
  end

  def total_daily_footprint
    object.total_pounds_logged.round(2).to_s
  end

  def personal
    h = object.household
    if h
    avg_monthly = (object.avg_daily_carbon_consumption * 29.53).round(2)
    household_avg = (h.avg_daily_carbon_consumed_per_user * 29.53).round(2)
    household_max = (h.calculate_house_carbon_max * 29.53).round(2)
    user_house_rank = object.user_carbon_rankings.where(area_type: "House").first.rank
    user_house_arrow = object.user_carbon_rankings.where(area_type: "House").first.arrow
    arr = [object.id, "Me", avg_monthly,
      household_avg, household_max,
      user_house_rank, h.users.count, user_house_arrow]
    end
    arr
  end

  def household
    h = object.household
    if h
      ranking = h.carbon_ranking
      avg_monthly = (h.avg_daily_carbon_consumed_per_user * 29.53).round(2)
      parent_avg = (h.address.neighborhood.avg_daily_carbon_consumed_per_user * 29.53).round(2)
      parent_max = (h.max_daily_carbon_consumption * 29.53).round(2)
      arr = [h.id, "Household", avg_monthly,
        parent_avg, parent_max,
        ranking.rank, ranking.out_of, ranking.arrow]
    end
    arr
  end
  def neighborhood
    n = object.neighborhood
    if n
      ranking = n.carbon_ranking
      avg_monthly = (n.avg_daily_carbon_consumed_per_user * 29.53).round(2)
      parent_avg = (n.city.avg_daily_carbon_consumed_per_user * 29.53).round(2)
      parent_max = (n.max_daily_carbon_consumption * 29.53).round(2)
      arr = [n.id, n.name, avg_monthly,
        parent_avg, parent_max,
        ranking.rank, ranking.out_of, ranking.arrow]
    end
    arr
  end
  def city
    c = object.city
    if c
      ranking = c.carbon_ranking
      avg_monthly = (c.avg_daily_carbon_consumed_per_user * 29.53).round(2)
      parent_avg = (c.region.avg_daily_carbon_consumed_per_user * 29.53).round(2)
      parent_max = (c.max_daily_carbon_consumption * 29.53).round(2)
      arr = [c.id, c.name, avg_monthly,
        parent_avg, parent_max,
        ranking.rank, ranking.out_of, ranking.arrow]
    end
    arr
  end
  def county
    c = object.county
    if c
      ranking = c.carbon_ranking
      avg_monthly = (c.avg_daily_carbon_consumed_per_user * 29.53).round(2)
      parent_avg = (c.region.avg_daily_carbon_consumed_per_user * 29.53).round(2)
      parent_max = (c.max_daily_carbon_consumption * 29.53).round(2)
      arr = [c.id, c.name, avg_monthly,
        parent_avg, parent_max,
        ranking.rank, ranking.out_of, ranking.arrow]
    end
    arr
  end
  def region
    r = object.region
    if r
      ranking = r.carbon_ranking
      avg_monthly = (r.avg_daily_carbon_consumed_per_user * 29.53).round(2)
      parent_avg = (r.country.avg_daily_carbon_consumed_per_user * 29.53).round(2)
      parent_max = (r.max_daily_carbon_consumption * 29.53).round(2)
      arr = [r.id, r.name, avg_monthly,
        parent_avg, parent_max,
        ranking.rank, ranking.out_of, ranking.arrow]
    end
    arr
  end
  def country
    c = object.country
    ## out of for country is 'inaccurate' but using all countries, not just ones with users
    if c
      ranking = c.carbon_ranking
      country_avg_carbon = Country.average(:avg_daily_carbon_consumed_per_user)
      avg_monthly = (c.avg_daily_carbon_consumed_per_user * 29.53).round(2)
      parent_avg = (country_avg_carbon * 29.53).round(2)
      parent_max = (c.max_daily_carbon_consumption * 29.53).round(2)
      arr = [c.id, c.name, avg_monthly,
        parent_avg, parent_max,
        ranking.rank, ranking.out_of, ranking.arrow]
    end
    arr
  end
  def avatar_url
    object.url
  end

  def personal_savings_to_date
    object.total_carbon_savings.to_f.round(2).to_s
  end

  def personal_usage_to_date
    object.total_pounds_logged.to_f.round(2).to_s
  end

  # def global_collective_savings
  #   Global.first.total_carbon_saved.to_f.round(2).to_s + " lbs"
  # end

  def household_daily_consumption
    object.household.average_daily_carbon_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end

  def neighborhood_daily_consumption
    object.neighborhood.carbon_ranking.avg_daily_carbon_consumed_per_user.to_f.round(2).to_s if !object.houses.empty?
  end

  def city_daily_consumption
    object.city.carbon_ranking.avg_daily_carbon_consumed_per_user.to_f.round(2).to_s if !object.houses.empty?
  end

  def county_daily_consumption
    object.county.carbon_ranking.avg_daily_carbon_consumed_per_user.to_f.round(2).to_s if !object.houses.empty?
  end

  def region_daily_consumption
    object.region.carbon_ranking.avg_daily_carbon_consumed_per_user.to_f.round(2).to_s if !object.houses.empty?
  end

  def country_daily_consumption
    object.country.carbon_ranking.avg_daily_carbon_consumed_per_user..to_f.round(2).to_s if !object.houses.empty?
  end
  def household_monthly_consumption
    (object.household.average_daily_carbon_consumption_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end

  def neighborhood_monthly_consumption
    (object.neighborhood.avg_daily_carbon_consumed_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end

  def city_monthly_consumption
    (object.city.avg_daily_carbon_consumed_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end

  def county_monthly_consumption
    (object.county.avg_daily_carbon_consumed_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end

  def region_monthly_consumption
    (object.region.avg_daily_carbon_consumed_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end

  def country_monthly_consumption
    (object.country.avg_daily_carbon_consumed_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
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
        n = Neighborhood.find(ops_[:area_id])
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

  def move_in_date
    UserHouse.where(user_id: object.id, house_id: object.household.id).first.move_in_date if object.household
  end

end
