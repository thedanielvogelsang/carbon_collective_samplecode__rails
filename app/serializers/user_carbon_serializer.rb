class UserCarbonSerializer < ActiveModel::Serializer
  attributes :id, :first, :avatar_url, :global_collective_savings,
                  :personal_savings_to_date,
                  :household, :neighborhood, :city, :region, :country,
                  :household_total_savings, :neighborhood_total_savings,
                  :city_total_savings, :region_total_savings,
                  :country_total_savings

  def neighborhood
    [object.neighborhood.id, object.neighborhood.name] if object.neighborhood
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

  def avatar_url
    object.url
  end

  def personal_savings_to_date
    object.total_carbon_savings.to_f.round(2).to_s + " lbs"
  end

  def global_collective_savings
    Global.first.total_carbon_saved.to_f.round(2).to_s + " lbs"
  end

  def household_total_savings
    object.household.total_carbon_savings_to_date if !object.houses.empty?
  end

  def neighborhood_total_savings
    object.neighborhood.carbon_ranking.total_carbon_saved.round(3)
  end

  def city_total_savings
    object.city.carbon_ranking.total_carbon_saved.round(3)

  end

  def region_total_savings
    object.region.carbon_ranking.total_carbon_saved.round(3)

  end

  def country_total_savings
    object.country.carbon_ranking.total_carbon_saved.round(3)
  end
end
