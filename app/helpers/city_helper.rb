module CityHelper
  include Co2Helper
  # serializer functions
  def out_of
    City.where(region: self.region).count
  end
  # update data and set data functions
  def update_data
    if self.users.count != 0
      # update_total_electricity_and_carbon_savings
      # update_daily_avg_electricity_savings
      update_daily_avg_electricity_consumption
      update_total_electricity_consumption
      # update_total_water_savings
      # update_daily_avg_water_savings
      update_daily_avg_water_consumption
      update_total_water_consumption
      # update_total_gas_and_carbon_savings
      # update_daily_avg_gas_savings
      update_daily_avg_gas_consumption
      update_total_gas_consumption

      update_carbon_consumption
      self.save
    end
  end

  # def update_total_electricity_and_carbon_savings
  #   if ElectricBill.joins(:house => :address).where(:addresses => {city_id: self.id}).count != 0
  #     energy_saved = self.users.map{|u| u.total_electricity_savings}
  #               .flatten.reject(&:nan?)
  #               .reduce(0){|sum, num| sum + num}
  #     self.total_electricity_saved = energy_saved
  #     carbon_ranking = self.carbon_ranking
  #     carbon_ranking.total_carbon_saved += kwhs_to_carbon(energy_saved)
  #     carbon_ranking.save
  #   end
  # end
  #
  # def update_daily_avg_electricity_savings
  #   if ElectricBill.joins(:house => :address).where(:addresses => {city_id: self.id}).count != 0
  #     energy_savings = self.users.map{|u| u.total_electricity_savings }
  #             .flatten.reject(&:nan?)
  #             .reduce(0){|sum, num| sum + num } / self.users.count if self.users.count != 0
  #     self.avg_total_electricity_saved_per_user = energy_savings
  #   end
  # end

  def update_daily_avg_electricity_consumption
    if ElectricBill.joins(:house => :address).where(:addresses => {city_id: self.id}).count != 0
      users = self.users.map{|u| u.avg_daily_electricity_consumption }
              .flatten.reject(&:nan?)
      ct = users.length
      energy_consumed = users.reduce(0){|sum, num| sum + num} / ct if ct != 0
      self.avg_daily_electricity_consumed_per_user = energy_consumed
    end
  end

  # def update_total_water_savings
  #   if WaterBill.joins(:house => :address).where(:addresses => {city_id: self.id}).count != 0
  #     water_saved = self.users.map{|u| u.total_water_savings}
  #               .flatten
  #               .reject(&:nan?)
  #               .reduce(0){|sum, num| sum + num}
  #     self.total_water_saved = water_saved
  #   end
  # end
  #
  # def update_daily_avg_water_savings
  #   if WaterBill.joins(:house => :address).where(:addresses => {city_id: self.id}).count != 0
  #     water_savings = self.users.map{|u| u.total_water_savings }
  #             .flatten
  #             .reject(&:nan?)
  #             .reduce(0){|sum, num| sum + num } / self.users.count if self.users.count != 0
  #     self.avg_total_water_saved_per_user = water_savings
  #   end
  # end

  def update_daily_avg_water_consumption
    if WaterBill.joins(:house => :address).where(:addresses => {city_id: self.id}).count != 0
      users = self.users.map{|u| u.avg_daily_water_consumption }
              .flatten
              .reject(&:nan?)
      ct = users.length
      water_consumed = users.reduce(0){|sum, num| sum + num} / ct if ct != 0
      self.avg_daily_water_consumed_per_user = water_consumed
    end
  end

  # def update_total_gas_and_carbon_savings
  #   if HeatBill.joins(:house => :address).where(:addresses => {city_id: self.id}).count != 0
  #     gas_saved = self.users.map{|u| u.total_gas_savings}
  #               .flatten.reject(&:nan?)
  #               .reduce(0){|sum, num| sum + num}
  #     self.total_gas_saved = gas_saved
  #     carbon_ranking = self.carbon_ranking
  #     carbon_ranking.total_carbon_saved += therms_to_carbon(gas_saved)
  #     carbon_ranking.save
  #   end
  # end
  #
  # def update_daily_avg_gas_savings
  #   if HeatBill.joins(:house => :address).where(:addresses => {city_id: self.id}).count != 0
  #     gas_savings = self.users.map{|u| u.total_gas_savings }
  #             .flatten.reject(&:nan?)
  #             .reduce(0){|sum, num| sum + num } / self.users.count if self.users.count != 0
  #     self.avg_total_gas_saved_per_user = gas_savings
  #   end
  # end

  def update_daily_avg_gas_consumption
    if HeatBill.joins(:house => :address).where(:addresses => {city_id: self.id}).count != 0
      users = self.users.map{|u| u.avg_daily_gas_consumption }
              .flatten.reject(&:nan?)
      ct = users.length
      gas_consumed = users.reduce(0){|sum, num| sum + num} / ct if ct != 0
      self.avg_daily_gas_consumed_per_user = gas_consumed
    end
  end

  def update_carbon_consumption
    carbon_ranking = self.carbon_ranking
    carbon_ranking.avg_daily_carbon_consumed_per_user = combine_average_use(self.avg_daily_electricity_consumed_per_user, self.avg_daily_gas_consumed_per_user)
    # carbon_ranking.avg_daily_carbon_consumed_per_user = n
    carbon_ranking.save
  end

  def update_total_electricity_consumption
    if ElectricBill.joins(:house => :address).where(:addresses => {city_id: self.id}).count != 0
      energy_consumed = self.users.map{|u| u.total_kwhs_logged }
              .flatten.reject(&:nan?)
              .reduce(0){|sum, num| sum + num}
      self.total_electricity_consumed = energy_consumed
    end
  end

  def update_total_water_consumption
    if WaterBill.joins(:house => :address).where(:addresses => {city_id: self.id}).count != 0
      water_consumed = self.users.map{|u| u.total_gallons_logged }
              .flatten
              .reject(&:nan?)
              .reduce(0){|sum, num| sum + num}
      self.total_water_consumed = water_consumed
    end
  end

  def update_total_gas_consumption
    if HeatBill.joins(:house => :address).where(:addresses => {city_id: self.id}).count != 0
      gas_consumed = self.users.map{|u| u.total_therms_logged }
              .flatten.reject(&:nan?)
              .reduce(0){|sum, num| sum + num}
      self.total_gas_consumed = gas_consumed
    end
  end
  def set_default_ranks
    WaterRanking.create(area_type: "City", area_id: self.id, rank: nil, arrow: nil)
    ElectricityRanking.create(area_type: "City", area_id: self.id, rank: nil, arrow: nil)
    GasRanking.create(area_type: "City", area_id: self.id, rank: nil, arrow: nil)
    CarbonRanking.create(area_type: "City", area_id: self.id, rank: nil, arrow: nil, total_carbon_saved: 0, avg_daily_carbon_consumed_per_user: 0)
  end
end
