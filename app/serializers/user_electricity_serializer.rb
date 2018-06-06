class UserElectricitySerializer < ActiveModel::Serializer
  attributes :id, :avg_daily_consumption, :first, :last, :email,
                  :avatar_url, :house_ids,
                  :last_updated,
                  :personal_savings_to_date,
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

  def personal_savings_to_date
    object.total_electricity_savings.to_f.round(2).to_s + " kwhs"
  end

  def global_collective_savings
    Global.first.total_energy_saved.to_f.round(2).to_s + " kwhs"
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
    object.household_daily_electricity_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def neighborhood_daily_consumption
    object.neighborhood_daily_electricity_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def city_daily_consumption
    object.city_daily_electricity_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def county_daily_consumption
    object.county_daily_electricity_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def region_daily_consumption
    object.region_daily_electricity_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def country_daily_consumption
    object.country_daily_electricity_consumption.to_f.round(2).to_s if !object.houses.empty?
  end
  def avg_daily_consumption
    object.avg_daily_electricity_consumption.round(2).to_s + " kwhs"
  end

  def last_updated
    object.user_electricity_ranking.updated_at
  end

  def metric_sym
    'kWhs'
  end
end
