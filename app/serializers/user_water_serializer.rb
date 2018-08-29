class UserWaterSerializer < ActiveModel::Serializer
  attributes :id, :avg_daily_consumption, :first, :last, :email,
                  :avatar_url, :house_ids, :avg_monthly_consumption,
                  :privacy_policy,
                  :last_updated, :rank, :arrow,
                  :personal_savings_to_date, :personal_usage_to_date,
                  :avg_daily_footprint, :avg_monthly_footprint,
                  :household, :neighborhood, :city, :county, :region, :country,
                  :household_monthly_consumption,
                  :neighborhood_monthly_consumption,
                  :city_monthly_consumption,
                  :region_monthly_consumption,
                  :country_monthly_consumption,
                  :metric_sym, :num_bills, :out_of

  def avg_daily_footprint
    object.avg_daily_carbon_consumption.round(2).to_s + " lbs" if object.avg_daily_carbon_consumption
  end
  def avg_monthly_footprint
    (object.avg_daily_carbon_consumption * 29.53).round(2).to_s + " lbs" if object.avg_daily_carbon_consumption
  end

  ## regional arrays for dash, order: [id, name, regional-avg, parent_avg, parent_max, regional-rank, out_of]
  def household
    h = object.household
    if h
      snapshot = h.household_snapshots.last
      arr = [h.id, "Household", snapshot.avg_daily_water_consumption_per_user,
        h.address.neighborhood.avg_daily_water_consumed_per_user,
        snapshot.max_daily_water_consumption,
        h.water_ranking.rank, snapshot.out_of]
    end
    arr
  end
  def neighborhood
    n = object.neighborhood
    if n
      snapshot = n.neighborhood_snapshots.last
      arr = [n.id, n.name, snapshot.avg_daily_water_consumption_per_user,
        n.city.avg_daily_water_consumed_per_user,
        snapshot.max_daily_water_consumption,
        n.water_ranking.rank, snapshot.out_of]
    end
    arr
  end
  def city
    c = object.city
    if c
      snapshot = c.city_snapshots.last
      arr = [c.id, c.name, snapshot.avg_daily_water_consumption_per_user,
        c.region.avg_daily_water_consumed_per_user,
        snapshot.max_daily_water_consumption,
        c.water_ranking.rank, snapshot.out_of]
    end
    arr
  end
  def county
    c = object.county
    if c
      snapshot = c.county_snapshots.last
      arr = [c.id, c.name, snapshot.avg_daily_water_consumption_per_user,
        c.region.avg_daily_water_consumed_per_user,
        snapshot.max_daily_water_consumption,
        c.water_ranking.rank, snapshot.out_of]
    end
    arr
  end
  def region
    r = object.region
    if r
      snapshot = r.region_snapshots.last
      arr = [r.id, r.name, snapshot.avg_daily_water_consumption_per_user,
        r.country.avg_daily_water_consumed_per_user,
        snapshot.max_daily_water_consumption,
        r.water_ranking.rank, snapshot.out_of]
    end
    arr
  end
  def country
    c = object.country
    ## out of for country is 'inaccurate' but using all countries, not just ones with users
    if c
      snapshot = c.country_snapshots.last
      arr = [c.id, c.name, snapshot.avg_daily_water_consumption_per_user,
        snapshot.country_avg_water,
        snapshot.max_daily_water_consumption,
        c.water_ranking.rank, Country.count]
    end
    arr
  end

  def personal_usage_to_date
    object.total_gallons_logged.to_f.round(2).to_s
  end
  def personal_savings_to_date
    object.total_water_savings.to_f.round(2).to_s
  end

  # def global_collective_savings
  #   Global.first.total_water_saved.to_f.round(2).to_s + " gallons"
  # end

  def current_location
    object.location
  end
  def trip_count
    object.trips.count
  end
  def admins
    admins = {}
    Group.joins(:admin)
         .where(:admins => {user_id: object.id})
         .each_with_index{|g,i| admins[i+1] = g.name}
    admins
  end
  def avatar_url
    object.url
  end
  def household_daily_consumption
    object.household_daily_water_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end
  def neighborhood_daily_consumption
    object.neighborhood_daily_water_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end
  def city_daily_consumption
    object.city_daily_water_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end

  def county_daily_consumption
    object.country_daily_water_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end
  def region_daily_consumption
    object.region_daily_water_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end
  def country_daily_consumption
    object.country_daily_water_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end
  def avg_daily_consumption
    avg = object.avg_daily_water_consumption.to_f
    avg.nan? ? "0" : avg.round(2).to_s
  end

  # monthly averages

  def household_monthly_consumption
    (object.household_daily_water_consumption_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end
  def neighborhood_monthly_consumption
    (object.neighborhood_daily_water_consumption_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end
  def city_monthly_consumption
    (object.city_daily_water_consumption_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end
  def county_monthly_consumption
    (object.country_daily_water_consumption_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end
  def region_monthly_consumption
    (object.region_daily_water_consumption_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end
  def country_monthly_consumption
    (object.country_daily_water_consumption_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end
  def avg_monthly_consumption
    avg = (object.avg_daily_water_consumption * 29.53).to_f
    avg.nan? ? "0" : avg.round(2).to_s
  end
  def arrow
    ops__ = @instance_options[:region]
    if ops__
      object.user_water_rankings
        .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].arrow
    else
      nil
    end
  end
  def rank
    ops__ = @instance_options[:region]
    if ops__
      object.user_water_rankings
        .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].rank
    else
      nil
    end
  end
  def last_updated
    ops__ = @instance_options[:region]
    if ops__
    object.user_water_rankings
          .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].updated_at
    else
      nil
    end
  end

  def metric_sym
    'gallons'
  end

  def num_bills
    object.water_bills_by_house(object.household.id).count if object.household
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
end
