module UserWaterHelper
  include UserHelper
  #
  # def avg_daily_water_savings
  #   self.total_gallons_logged / self.total_waterbill_days_logged
  # end

  def avg_daily_water_consumption
    res_ = self.total_gallons_logged.fdiv(self.total_waterbill_days_logged)
    return res_.nan? ? 0.0 : res_
  end

  def water_bills_by_house(house_id)
    uh = UserHouse.where(house_id: house_id, user_id: self.id)[0]
    WaterBill.joins(:house).where(:houses => {id: house_id}).order(end_date: :desc)
        .select{|b| b.start_date > uh.move_in_date}
  end

# check
  def household_daily_water_consumption_per_user
    household ? household.average_daily_water_consumption_per_user : nil
  end

  def neighborhood_daily_water_consumption_per_user
    household.address.neighborhood ? household.address.neighborhood.avg_daily_water_consumed_per_user : nil
  end

  def city_daily_water_consumption_per_user
    household ? household.address.city.avg_daily_water_consumed_per_user : nil
  end

  def county_daily_water_consumption_per_user
    household ? household.address.county.avg_daily_water_consumed_per_user : nil
  end

  def region_daily_water_consumption_per_user
    household ? household.address.city.region.avg_daily_water_consumed_per_user : nil
  end

  def country_daily_water_consumption_per_user
    household ? household.address.city.region.country.avg_daily_water_consumed_per_user : nil
  end

  def re_calculate_water_history(orig, mid)
    ## Removing old totals
    bills = household.water_bills.select{|b| b.start_date >= orig}

    total_days = bills.map{|b| b.end_date - b.start_date}.sum.to_i
    total_use = bills.map{|b| b.average_daily_usage * (b.end_date - b.start_date).to_f}.sum
    total_saved = bills.map{|b| b.water_saved.fdiv((b.end_date - b.start_date).to_i)}.sum

        self.total_waterbill_days_logged -= total_days
        self.total_gallons_logged -= total_use
        self.total_water_savings -= total_saved

    ## Adding new totals
    bills = household.water_bills.select{|b| b.start_date >= mid}

    new_days =  bills.map{|b| b.end_date - b.start_date}.sum.to_i
    new_use = bills.map{|b| b.average_daily_usage * (b.end_date - b.start_date).to_f}.sum
    new_savings = bills.map{|b| b.water_saved.fdiv((b.end_date - b.start_date).to_i)}.sum

        self.total_waterbill_days_logged += new_days
        self.total_gallons_logged += new_use
        self.total_water_savings += new_savings

    # CREATING NEW USER_WATER_BILLS
    bills.each{|b| UserWaterBill.find_or_create_by(user_id: id, water_bill_id: b.id)}
  end
end
