module UserGasHelper
  include UserHelper
  include Co2Helper
  #
  # def avg_daily_gas_savings
  #   self.total_therms_logged / self.total_heatbill_days_logged
  # end

  def avg_daily_gas_consumption
    res_ = self.total_therms_logged.fdiv(self.total_heatbill_days_logged)
    return res_.nan? ? 0.0 : res_
  end

  def gas_bills_by_house(house_id)
    uh = UserHouse.where(house_id: house_id, user_id: self.id)[0]
    HeatBill.joins(:house).where(:houses => {id: house_id}).order(end_date: :desc)
        .select{|b| b.start_date > uh.move_in_date}
  end

# check
  def household_daily_gas_consumption_per_user
    household ? household.average_daily_gas_consumption_per_user : nil
  end

  def neighborhood_daily_gas_consumption_per_user
    household.address.neighborhood ? household.address.neighborhood.avg_daily_gas_consumed_per_user : nil
  end

  def city_daily_gas_consumption_per_user
    household ? household.address.city.avg_daily_gas_consumed_per_user : nil
  end

  def county_daily_gas_consumption_per_user
    household ? household.address.county.avg_daily_gas_consumed_per_user : nil
  end

  def region_daily_gas_consumption_per_user
    household ? household.address.city.region.avg_daily_gas_consumed_per_user : nil
  end

  def country_daily_gas_consumption_per_user
    household ? household.address.city.region.country.avg_daily_gas_consumed_per_user : nil
  end

  def re_calculate_gas_history(orig, mid)
    total_days = household.heat_bills.select{|b| b.start_date >= orig}
                          .map{|b| b.end_date - b.start_date}.sum.to_i
    total_use = household.heat_bills.select{|b| b.start_date >= orig}
                          .map{|b| b.average_daily_usage * (b.end_date - b.start_date).to_f}.sum
    total_saved = household.heat_bills.select{|b| b.start_date >= orig}
                          .map{|b| b.gas_saved.fdiv((b.end_date - b.start_date).to_i)}.sum
        self.total_heatbill_days_logged -= total_days
        self.total_therms_logged -= total_use
        self.total_gas_savings -= total_saved

    new_days = household.heat_bills.select{|b| b.start_date >= mid}
                          .map{|b| b.end_date - b.start_date}.sum.to_i
    new_use = household.heat_bills.select{|b| b.start_date >= mid}
                          .map{|b| b.average_daily_usage * (b.end_date - b.start_date).to_f}.sum
    new_savings = household.heat_bills.select{|b| b.start_date >= mid}
                          .map{|b| b.gas_saved.fdiv((b.end_date - b.start_date).to_i)}.sum
        self.total_heatbill_days_logged += new_days
        self.total_therms_logged += new_use
        self.total_gas_savings += new_savings

    # adjust carbon record
    self.total_pounds_logged -= therms_to_carbon(total_use)
    self.total_pounds_logged += therms_to_carbon(new_use)
    self.total_carbon_savings -= therms_to_carbon(total_saved)
    self.total_carbon_savings += therms_to_carbon(new_savings)
  end

end
