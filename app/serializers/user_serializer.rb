class UserSerializer < ActiveModel::Serializer
  attributes :id, :first, :last, :email,
                  :avatar_url, :house_ids,
                  :total_carbon_savings_to_date,
                  :global_collective_carbon_savings,
                  :privacy_policy, :house,
                  :invite_max,
                  :slug,
                  :move_in_date,
                  # :avg_daily_footprint,
                  # :avg_monthly_footprint,
                  :household, :neighborhood, :city, :county, :region, :country,
                  :checklists_left, :invites_left, :bills_left, :resources_entered

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

  def move_in_date
    UserHouse.where(user_id: object.id, house_id: object.household.id)[0].move_in_date if object.household
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

  def checklists_left
    ct = 0
    if !object.user_electricity_questions.empty?
      ct += 1 if !object.user_electricity_questions.first.completed?
      ct += 1 if !object.user_water_questions.first.completed?
      ct += 1 if !object.user_gas_questions.first.completed?
    end
    if ct === 0
      return nil
    else
      return ct
    end
  end

  def bills_left
    ct = 0
    if !object.household
      ct += 1 if object.household.bills.empty?
      ct += 1 if object.household.wbills.empty?
      ct += 1 if object.household.gbills.empty?
    end
    if ct === 0
      return nil
    else
      return ct
    end
  end

  def invites_left
    num = object.invite_max - object.invites.count
    if num === 0
      return nil
    else
      return num
    end
  end

  def resources_entered

  end
end
