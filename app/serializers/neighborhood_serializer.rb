class NeighborhoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :number_of_users_in_neighborhood, :city, :region, :country,
                  :total_electricity_consumption_to_date,
                  :total_electricity_savings_to_date,
                  :avg_total_electricity_consumption_per_capita,
                  :avg_monthly_electricity_consumption_per_capita,
                  :avg_total_electricity_savings_per_capita,
                  :avg_monthly_electricity_savings_per_capita

  def total_electricity_consumption_to_date
  object.total_electricity_consumption_to_date.to_s + ' kwhs consumed to date'
  end
  def total_electricity_savings_to_date
  object.total_electricity_savings_to_date.to_s + ' kwhs electricity saved to date'
  end
  def avg_total_electricity_consumption_per_capita
  (object.avg_total_electricity_consumption_per_capita).to_s + ' total kwhs consumed per capita' if object.avg_total_electricity_consumption_per_capita != nil
  end
  def avg_monthly_electricity_consumption_per_capita
  (object.avg_monthly_electricity_consumption_per_capita).to_s + ' kwhs consumed per capita per month' if object.total_electricity_consumption_to_date != nil
  end
  def avg_total_electricity_savings_per_capita
  (object.avg_total_electricity_savings_per_capita).to_s + ' total kwhs of electricity saved per capita' if object.avg_total_electricity_savings_per_capita != nil
  end
  def avg_monthly_electricity_savings_per_capita
  (object.avg_monthly_electricity_savings_per_capita).to_s + ' kwhs of electricity saved per capita per month' if object.avg_monthly_electricity_savings_per_capita != nil
  end

  def city
    object.city.name
  end
  def region
    object.city.region.name
  end
  def country
    object.city.region.country.name
  end

  def number_of_users_in_neighborhood
    object.users.count
  end
end
