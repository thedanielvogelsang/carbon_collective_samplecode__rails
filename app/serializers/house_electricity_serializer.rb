class HouseElectricitySerializer < ActiveModel::Serializer
  attributes :id, :total_sq_ft, :no_residents, :address, :neighborhood,
                  :users_names, :users_ids, :no_users, :number_of_bills_entered,
                  :apartment, :total_spent, :total_days_recorded,
                  :total_consumption_to_date, :metric_sym, :out_of,
                  :total_savings_to_date, :move_in_date,
                  :avg_daily_consumption_per_resident,
                  :avg_monthly_consumption_per_resident,
                  :avg_daily_consumption_per_user,
                  :avg_monthly_consumption_per_user,
                  :arrow, :rank,
                  :avg_daily_consumption
                  :avg_monthly_consumption


  def total_days_recorded
    object.total_electricitybill_days_recorded
  end
  def total_sq_ft
    object.total_sq_ft || 0
  end
  def total_consumption_to_date
    object.total_electricity_consumption_to_date.round(2).to_s + " kWhs" if object.total_electricity_consumption_to_date
  end
  def total_savings_to_date
    object.total_electricity_savings_to_date.round(2) if object.total_electricity_savings_to_date
  end
  def avg_daily_consumption_per_user
    (object.avg_daily_electricity_consumed_per_user).round(2)
  end
  def avg_monthly_consumption_per_user
    (object.avg_daily_electricity_consumed_per_user * 29.53).round(2)
  end
  def avg_daily_consumption_per_resident
    (object.average_daily_electricity_consumption_per_resident).round(2) if object.average_daily_electricity_consumption_per_user != nil
  end
  def avg_monthly_consumption_per_resident
    (object.average_daily_electricity_consumption_per_resident * 29.53).round(2) if object.average_daily_electricity_consumption_per_user != nil
  end
  def avg_daily_consumption
    (object.avg_daily_electricity_consumed_per_user * object.no_residents).round(2)
  end
  def avg_monthly_consumption
    (object.avg_daily_electricity_consumed_per_user * 29.53 * object.no_residents).round(2)
  end
  # def avg_total_savings
  #   (object.avg_total_electricity_savings_per_resident * object.no_residents).round(2) if object.avg_total_electricity_savings_per_user != nil
  # end

  def total_spent
    object.bills.map{|b| b.price}.reject(&:nil?).reduce(0){|s, n| s+ n} if !object.bills.empty?
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

  def users_ids
    object.users.map{|u| u.id}
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
    "kWhs"
  end
  def out_of
    House.all.count
  end
  def rank
    object.electricity_ranking.rank
  end
  def arrow
    object.electricity_ranking.arrow
  end

  def move_in_date
    if @instance_options[:user]
      user = User.friendly.find(@instance_options[:user])
      uh = object.user_houses.where(:user_houses => {user_id: user.id}).first
      uh.move_in_date.strftime("%Y-%m-%d")
    else
      nil
    end
  end
end
