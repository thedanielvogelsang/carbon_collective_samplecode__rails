class UserSerializer < ActiveModel::Serializer
  attributes :id, :first, :last, :email,
                  :avatar_url, :house_ids,
                  :total_carbon_savings_to_date,
                  :global_collective_carbon_savings,
                  :privacy_policy, :house,
                  # :avg_daily_footprint,
                  # :avg_monthly_footprint,
                  :household, :neighborhood, :city, :county, :region, :country,

  def house
    object.household
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

  # needs to be erased or fixed

  # def avg_daily_footprint
  #   object.total_pounds_logged.to_s + " lbs"
  # end
  # def avg_monthly_footprint
  #   (object.total_pounds_logged).to_s + " lbs"
  # end
  def house_ids
    object.houses.map{|h| h.id} if object.houses.length > 0
  end

  def total_carbon_savings_to_date
    object.total_electricity_savings.to_f.round(2).to_s + " kWhs"
  end

  def global_collective_carbon_savings
    Global.first.total_energy_saved.to_f.round(2).to_s + " kWhs"
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
end
