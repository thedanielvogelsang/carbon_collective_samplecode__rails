class HouseSerializer < ActiveModel::Serializer
  attributes :id, :total_sq_ft, :number_residents, :address, :users_id, :number_of_bills_entered,
                  :total_electricity_consumption_to_date,
                  :total_electricity_savings_to_date,
                  :avg_total_electricity_consumption_per_resident,
                  :avg_monthly_electricity_consumption_per_resident,
                  :avg_total_electricity_savings_per_resident,
                  :avg_monthly_electricity_savings_per_resident

  def total_electricity_consumption_to_date
    object.total_electricity_consumption_to_date.to_s + ' kwhs consumed to date'
  end
  def total_electricity_savings_to_date
    object.total_electricity_savings_to_date.to_s + ' kwhs electricity saved to date'
  end
  def avg_total_electricity_consumption_per_resident
    (object.avg_total_electricity_consumption_per_resident).to_s + ' kwhs per house member' if object.avg_total_electricity_consumption_per_resident != nil
  end
  def avg_monthly_electricity_consumption_per_resident
    (object.avg_monthly_electricity_consumption_per_resident).to_s + ' kwhs per house member per month' if object.total_electricity_consumption_to_date != nil
  end
  def avg_total_electricity_savings_per_resident
    (object.avg_total_electricity_savings_per_resident).to_s + ' kwhs of electricity saved per house member' if object.avg_total_electricity_savings_per_resident != nil
  end
  def avg_monthly_electricity_savings_per_resident
    (object.avg_monthly_electricity_savings_per_resident).to_s + ' kwhs of electricity saved per house member per month' if object.avg_monthly_electricity_savings_per_resident != nil
  end

  def number_of_bills_entered
    {
      "number of bills" => object.bills.count,
      "bill ids" => object.bills.map{|b| b.id}
    }
  end
  def number_residents
    object.no_residents
  end

  def users_id
    object.users.map{|u| u.id}
  end

  def address
    object.address
  end
end
