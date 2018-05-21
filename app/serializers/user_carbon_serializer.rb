class UserCarbonSerializer < ActiveRecordSerializer
  attributes :id, :first, :avatar_url, :global_collective_savings,
                  :household_total_savings, :neighborhood_total_savings,
                  :city_total_savings, :region_total_savings,
                  :country_total_savings

  def avatar_url
    object.url
  end

  def household_total_savings
    object.household.whatever if !object.houses.empty?
  end

  def neighborhood_total_savings
    object.neighborhood.carbon_rankings.total_carbon_saved.round(3)
  end

  def city_total_savings
    object.city.carbon_rankings.total_carbon_saved.round(3)

  end

  def region_total_savings
    object.region.carbon_rankings.total_carbon_saved.round(3)

  end

  def country_total_savings
    object.country.carbon_rankings.total_carbon_saved.round(3)
  end
end
