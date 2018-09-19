class HouseGasSerializer < ActiveModel::Serializer
  attributes :id, :total_sq_ft, :no_residents, :address, :neighborhood,
                  :users_names, :users_ids, :no_users, :number_of_bills_entered,
                  :apartment, :total_spent, :total_days_recorded,
                  :total_consumption_to_date, :metric_sym, :out_of,
                  :arrow, :rank, :move_in_date,
                  :total_savings_to_date,
                  :avg_daily_consumption,
                  :avg_monthly_consumption,
                  :avg_daily_consumption_per_resident,
                  :avg_monthly_consumption_per_resident,
                  :avg_daily_consumption_per_user,
                  :avg_monthly_consumption_per_user

  def total_days_recorded
    object.total_heatbill_days_recorded
  end
  def total_consumption_to_date
    object.total_gas_consumption_to_date.round(2).to_s + " therms"
  end
  def total_savings_to_date
    object.total_gas_savings_to_date.round(2)
  end

  #per user
  def avg_daily_consumption_per_user
    (object.avg_daily_gas_consumed_per_user).round(2) if object.average_daily_gas_consumption_per_user != nil
  end
  def avg_monthly_consumption_per_user
    (object.avg_daily_gas_consumed_per_user * 29.53).round(2) if object.average_daily_gas_consumption_per_user != nil
  end
  #per resident
  def avg_daily_consumption_per_resident
    (object.average_daily_gas_consumption_per_resident).round(2) if object.average_daily_gas_consumption_per_resident != nil
  end
  def avg_monthly_consumption_per_resident
    (object.average_daily_gas_consumption_per_resident * 29.53).round(2) if object.average_daily_gas_consumption_per_resident != nil
  end
  #all
  def avg_daily_consumption
    (object.avg_daily_gas_consumed_per_user * object.no_residents).round(2) if object.average_daily_gas_consumption_per_user != nil
  end
  def avg_monthly_consumption
    (object.avg_daily_gas_consumed_per_user * 29.53 * object.no_residents).round(2) if object.average_daily_gas_consumption_per_user != nil
  end

  def total_spent
    object.heat_bills.map{|b| b.price}.reduce(0){|s, n| s+ n} if !object.heat_bills.empty?
  end
  def number_of_bills_entered
    {
      "number of bills" => object.heat_bills.count,
      "bill ids" => object.heat_bills.map{|b| b.id}
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
  def total_days_recorded
    object.heat_bills.count
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
    "therms"
  end
  def out_of
    object.household_snapshots.last.out_of
  end
  def rank
    object.gas_ranking.rank
  end
  def arrow
    object.gas_ranking.arrow
  end
  def move_in_date
    if @instance_options[:user]
      uh = object.user_houses.where(:user_houses => {user_id: @instance_options[:user]}).first
      uh.move_in_date.strftime("%Y-%m-%d")
    else
      nil
    end
  end
end
