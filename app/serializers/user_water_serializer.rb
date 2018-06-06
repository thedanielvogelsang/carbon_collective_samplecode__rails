class UserWaterSerializer < ActiveModel::Serializer
  attributes :id, :avg_daily_consumption, :first, :last, :email,
                  :avatar_url, :house_ids,
                  :last_updated, :rank, :arrow,
                  :personal_savings_to_date, :personal_usage_to_date,
                  :global_collective_savings,
                  :household, :neighborhood, :city, :county, :region, :country,
                  :household_daily_consumption,
                  :neighborhood_daily_consumption,
                  :city_daily_consumption,
                  :county_daily_consumption,
                  :region_daily_consumption,
                  :country_daily_consumption,
                  :metric_sym

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

  def personal_usage_to_date
    object.total_gallons_logged.to_f.round(2).to_s + " gallons"
  end

  def personal_savings_to_date
    object.total_water_savings.to_f.round(2).to_s + " gallons"
  end

  def global_collective_savings
    Global.first.total_water_saved.to_f.round(2).to_s + " gallons"
  end

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
    object.household_daily_water_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def neighborhood_daily_consumption
    object.neighborhood_daily_water_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def city_daily_consumption
    object.city_daily_water_consumption.to_f.round(2).to_s if !object.houses.empty?
  end

  def county_daily_consumption
    object.country_daily_water_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def region_daily_consumption
    object.region_daily_water_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def country_daily_consumption
    object.country_daily_water_consumption.to_f.round(2).to_s if !object.houses.empty?
  end

  def avg_daily_consumption
    object.avg_daily_water_consumption.round(2).to_s + " gals"
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
end
