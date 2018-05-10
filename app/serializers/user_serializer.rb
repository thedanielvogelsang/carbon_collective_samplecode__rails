class UserSerializer < ActiveModel::Serializer
  attributes :id, :first, :last, :email,
                  :avatar_url, :house_ids,
                  :total_electricity_savings_to_date,
                  :global_collective_electricity_savings, :address,
                  :household, :neighborhood, :city, :region, :country,
                  :household_total_savings,
                  :neighborhood_total_savings,
                  :city_total_savings,
                  :region_total_savings,
                  :country_total_savings

  def neighborhood
    [object.neighborhood.id, object.neighborhood] if object.neighborhood
  end
  def city
    [object.city.id, object.city.name] if object.city
  end
  def region
    [object.region.id, object.region.name] if object.region
  end
  def country
    [object.country.id, object.country.name] if object.country
  end

  def house_ids
    object.houses.map{|h| h.id} if object.houses.length > 0
  end

  def total_electricity_savings_to_date
    object.total_electricity_savings.to_f.round(2).to_s + " kwhs"
  end

  def global_collective_electricity_savings
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
    object.household_total_savings.to_f.round(2).to_s if !object.houses.empty?
  end
  def neighborhood_total_savings
    object.neighborhood_total_savings.to_f.round(2).to_s if !object.houses.empty?
  end
  def city_total_savings
    object.city_total_savings.to_f.round(2).to_s if !object.houses.empty?
  end
  def region_total_savings
    object.region_total_savings.to_f.round(2).to_s if !object.houses.empty?
  end
  def country_total_savings
    object.country_total_savings.to_f.round(2).to_s if !object.houses.empty?
  end
end
