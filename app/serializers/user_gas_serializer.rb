class UserGasSerializer < ActiveModel::Serializer
  attributes :id, :avg_daily_consumption, :first, :last, :email,
                  :avatar_url, :house_ids, :avg_monthly_consumption,
                  :privacy_policy,
                  :rank, :arrow, :last_updated,
                  :personal_usage_to_date, :personal_savings_to_date,
                  :avg_daily_footprint, :avg_monthly_footprint,
                  :household, :neighborhood, :city, :county, :region, :country,
                  :household_monthly_consumption,
                  :neighborhood_monthly_consumption,
                  :city_monthly_consumption,
                  :county_monthly_consumption,
                  :region_monthly_consumption,
                  :country_monthly_consumption,
                  :metric_sym, :num_bills, :out_of
  def avg_daily_footprint
    object.avg_daily_carbon_consumption.round(2).to_s + " lbs" if object.avg_daily_carbon_consumption
  end
  def avg_monthly_footprint
    object.avg_daily_carbon_consumption.round(2).to_s + " lbs" if object.avg_daily_carbon_consumption
  end
  def neighborhood
    [object.neighborhood.id, object.neighborhood.name, object.neighborhood.gas_ranking.rank, object.neighborhood.out_of] if object.neighborhood
  end
  def city
    [object.city.id, object.city.name, object.city.gas_ranking.rank, object.city.out_of] if object.city
  end
  def county
    [object.county.id, object.county.name, object.county.gas_ranking.rank, object.county.out_of] if object.county
  end
  def region
    [object.region.id, object.region.name, object.region.gas_ranking.rank, object.region.out_of] if object.region
  end
  def country
    [object.country.id, object.country.name, object.country.gas_ranking.rank, object.country.out_of] if object.country
  end

  def house_ids
    object.houses.map{|h| h.id} if object.houses.length > 0
  end

  def personal_usage_to_date
    object.total_therms_logged.to_f.round(2).to_s + " therms"
  end

  def personal_savings_to_date
    object.total_gas_savings.to_f.round(2).to_s + " therms"
  end
  # 
  # def global_collective_savings
  #   nil
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
    object.household_daily_gas_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def neighborhood_daily_consumption
    object.neighborhood_daily_gas_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def city_daily_consumption
    object.city_daily_gas_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def county_daily_consumption
    object.county_daily_gas_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def region_daily_consumption
    object.region_daily_gas_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def country_daily_consumption
    object.country_daily_gas_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def avg_daily_consumption
    avg = object.avg_daily_gas_consumption.to_f
    avg.nan? ? "0 therms" : avg.round(2).to_s + " therms"
  end

  #monthly averages
  def household_monthly_consumption
    (object.household_daily_gas_consumption * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end
  def neighborhood_monthly_consumption
    (object.neighborhood_daily_gas_consumption * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end
  def city_monthly_consumption
    (object.city_daily_gas_consumption.to_f * 29.53).round(2).to_s if !object.houses.empty?
  end
  def county_monthly_consumption
    (object.county_daily_gas_consumption.to_f * 29.53).round(2).to_s if !object.houses.empty?
  end
  def region_monthly_consumption
    (object.region_daily_gas_consumption.to_f * 29.53).round(2).to_s if !object.houses.empty?
  end
  def country_monthly_consumption
    (object.country_daily_gas_consumption.to_f * 29.53).round(2).to_s if !object.houses.empty?
  end
  def avg_monthly_consumption
    avg = (object.avg_daily_gas_consumption * 29.53).to_f
    avg.nan? ? "0 therms" : avg.round(2).to_s + " therms"
  end

  def arrow
    ops__ = @instance_options[:region]
    if ops__
      object.user_gas_rankings
        .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].arrow
    else
      nil
    end
  end

  def rank
    ops__ = @instance_options[:region]
    if ops__
      object.user_gas_rankings
        .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].rank
    else
      nil
    end
  end

  def last_updated
    ops__ = @instance_options[:region]
    if ops__
    object.user_gas_rankings
          .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].updated_at
    else
      nil
    end
  end
  def metric_sym
    'therms'
  end
  def num_bills
    object.household.heat_bills.count
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
