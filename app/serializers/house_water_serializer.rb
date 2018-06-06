class HouseWaterSerializer < ActiveModel::Serializer
  attributes :id, :total_sq_ft, :no_residents, :address, :neighborhood,
                  :users_names, :users_ids, :no_users, :number_of_bills_entered,
                  :apartment, :total_price, :total_days_recorded,
                  :total_consumption_to_date,
                  :total_savings_to_date,
                  :avg_daily_consumption_per_resident,
                  :avg_total_savings_per_resident,

  def total_consumption_to_date
    object.total_water_consumption_to_date.round(1).to_s + " gallons"
  end
  def total_savings_to_date
    object.total_water_savings_to_date
  end
  def avg_daily_consumption_per_resident
    (object.average_daily_water_consumption_per_resident).round(2) if object.average_daily_water_consumption_per_resident != nil
  end
  def avg_total_savings_per_resident
    (object.avg_total_water_savings_per_resident).round(2) if object.avg_total_water_savings_per_resident != nil
  end

  def total_price
    500
  end

  def number_of_bills_entered
    {
      "number of bills" => object.bills.count,
      "bill ids" => object.bills.map{|b| b.id}
    }
  end

  def no_users
    object.users.count
  end

  def users_names
    object.users.map{|u| u.first + ' ' + u.last}
  end

  def users_ids
    object.users.map{|u| u.id}
  end

  def address
    addy = object.address
    addy.address_line1 + " #{addy.address_line2.to_s}" +
        ', ' + addy.city.name + ', ' +
          addy.region.name
  end

  def neighborhood
    object.neighborhood
  end
end
