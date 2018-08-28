class HouseCarbonSerializer < ActiveModel::Serializer
  attributes :id, :total_sq_ft, :no_residents, :address, :neighborhood,
                  :users_names, :users_ids, :no_users, :number_of_bills_entered,
                  :apartment, :total_spent, :total_days_recorded,
                  :total_consumption_to_date, :metric_sym, :out_of
                  :total_savings_to_date,
                  :avg_daily_consumption,
                  :avg_monthly_consumption,
                  :avg_daily_consumption_per_resident,
                  :avg_monthly_consumption_per_resident,
                  :avg_daily_consumption_per_user,
                  :avg_monthly_consumption_per_user,

  def total_days_recorded
    object.total_days_recorded.to_s + " days (all bills to date)"
  end
  def total_consumption_to_date
    object.total_carbon_consumption_to_date.round(2).to_s + " pounds"
  end
  def total_savings_to_date
    object.total_carbon_savings_to_date.round(2)
  end

  def avg_daily_consumption_per_user
    (object.avg_daily_carbon_consumed_per_user).round(2)
  end
  def avg_monthly_consumption_per_user
    (object.avg_daily_carbon_consumed_per_user * 29.53).round(2)
  end
  def avg_daily_consumption_per_resident
    (object.average_daily_carbon_consumption_per_resident).round(2) if object.average_daily_carbon_consumption_per_resident != nil
  end
  def avg_monthly_consumption_per_resident
    (object.average_daily_carbon_consumption_per_resident * 29.53).round(2) if object.average_daily_carbon_consumption_per_resident != nil
  end
  def avg_daily_consumption
    (object.avg_daily_carbon_consumed_per_user * object.no_residents).round(2)
  end
  def avg_monthly_consumption
    (object.avg_daily_carbon_consumed_per_user * 29.53 * object.no_residents).round(2)
  end

  def total_spent
    object.total_spent
  end

  def number_of_bills_entered
    {
      "number of bills" => object.bills.count,
      "bill ids" => object.bills.map{|b| b.id}
    }
  end

  def users_ids
    object.users.map{|u| u.id}
  end

  def no_users
    object.users.count
  end

  def users_names
    object.users.map{|u| u.first + ' ' + u.last}
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
  def metric_sym
    "lbs"
  end
  def out_of
    object.household_snapshots.last.out_of
  end
end
