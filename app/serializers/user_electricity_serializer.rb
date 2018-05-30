class UserElectricitySerializer < ActiveModel::Serializer
  attributes :id, :total_savings, :first, :last, :email,
                  :avatar_url, :house_ids,
                  :rank, :arrow, :last_updated,
                  :personal_savings_to_date,
                  :global_collective_savings,
                  :household, :neighborhood, :city, :county, :region, :country,
                  :household_total_savings,
                  :neighborhood_total_savings,
                  :city_total_savings,
                  :county_total_savings,
                  :region_total_savings,
                  :country_total_savings,
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

  def household_total_savings
    object.household_total_electricity_savings.to_f.round(2).to_s if !object.houses.empty?
  end
  def neighborhood_total_savings
    object.neighborhood_total_electricity_savings.to_f.round(2).to_s if !object.houses.empty?
  end
  def city_total_savings
    object.city_total_electricity_savings.to_f.round(2).to_s if !object.houses.empty?
  end
  def county_total_savings
    object.county_total_electricity_savings.to_f.round(2).to_s if !object.houses.empty?
  end
  def region_total_savings
    object.region_total_electricity_savings.to_f.round(2).to_s if !object.houses.empty?
  end
  def country_total_savings
    object.country_total_electricity_savings.to_f.round(2).to_s if !object.houses.empty?
  end
  def total_savings
    object.total_electricity_savings.round(2).to_s + " kwhs"
  end
  def rank
    object.user_electricity_ranking.rank
  end

  def arrow
    object.user_electricity_ranking.arrow
  end

  def last_updated
    object.user_electricity_ranking.updated_at
  end

  def metric_sym
    'kWhs'
  end
end
