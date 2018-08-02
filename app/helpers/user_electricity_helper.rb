module UserElectricityHelper

  include UserHelper

  # def avg_daily_electricity_savings
  #   self.total_kwhs_logged / self.total_electricitybill_days_logged
  # end

  def avg_daily_electricity_consumption
    res_ = self.total_kwhs_logged.fdiv(self.total_electricitybill_days_logged)
    return res_.nan? ? 0.0 : res_
  end

  def electric_bills(house_id)
    uh = UserHouse.where(house_id: house_id, user_id: self.id)
    ElectricBill.joins(:house).where(:houses => {id: house_id}).order(end_date: :desc)
          .select{|b| b.start_date > uh.move_in_date}
  end

# check
  def household_daily_electricity_consumption_per_user
    household ? household.average_daily_electricity_consumption_per_user : nil
  end

  def neighborhood_daily_electricity_consumption_per_user
    household.address.neighborhood ? household.address.neighborhood.avg_daily_electricity_consumed_per_user : nil
  end

  def city_daily_electricity_consumption_per_user
    household ? household.address.city.avg_daily_electricity_consumed_per_user : nil
  end

  def county_daily_electricity_consumption_per_user
    household ? household.address.county.avg_daily_electricity_consumed_per_user : nil
  end

  def region_daily_electricity_consumption_per_user
    household ? household.address.city.region.avg_daily_electricity_consumed_per_user : nil
  end

  def country_daily_electricity_consumption_per_user
    household ? household.address.city.region.country.avg_daily_electricity_consumed_per_user : nil
  end

end
