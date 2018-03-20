class CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :number_of_users_in_city, :region, :country,
                  :total_energy_consumption_to_date,
                  :total_carbon_savings_to_date,
                  :avg_total_energy_consumption_per_capita,
                  :avg_monthly_energy_consumption_per_capita,
                  :avg_total_carbon_savings_per_capita,
                  :avg_monthly_carbon_savings_per_capita

  def total_energy_consumption_to_date
  object.total_energy_consumption_to_date.to_s + ' kwhs consumed to date'
  end
  def total_carbon_savings_to_date
  object.total_carbon_savings_to_date.to_s + ' lbs carbon saved to date'
  end
  def avg_total_energy_consumption_per_capita
  (object.avg_total_energy_consumption_per_capita).to_s + ' total kwhs consumed per capita' if object.avg_total_energy_consumption_per_capita != nil
  end
  def avg_monthly_energy_consumption_per_capita
  (object.avg_monthly_energy_consumption_per_capita).to_s + ' kwhs consumed per capita per month' if object.total_energy_consumption_to_date != nil
  end
  def avg_total_carbon_savings_per_capita
  (object.avg_total_carbon_savings_per_capita).to_s + ' total lbs of carbon saved per capita' if object.avg_total_carbon_savings_per_capita != nil
  end
  def avg_monthly_carbon_savings_per_capita
  (object.avg_monthly_carbon_savings_per_capita).to_s + ' lbs of carbon saved per capita per month' if object.avg_monthly_carbon_savings_per_capita != nil
  end

  def region
    object.region.name
  end
  def country
    object.region.country.name
  end
  def number_of_users_in_city
    object.users.count
  end
end
