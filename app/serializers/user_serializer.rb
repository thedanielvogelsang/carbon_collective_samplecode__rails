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

  def house_ids
    object.houses.map{|h| h.id}
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
    object.household_total_savings.to_f.round(2).to_s
  end
  def neighborhood_total_savings
    object.neighborhood_total_savings.to_f.round(2)
  end
  def city_total_savings
    object.city_total_savings.to_f.round(2)
  end
  def region_total_savings
    object.region_total_savings.to_f.round(2)
  end
  def country_total_savings
    object.country_total_savings.to_f.round(2)
  end
end
