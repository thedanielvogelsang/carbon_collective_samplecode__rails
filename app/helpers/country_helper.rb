module CountryHelper
  include Co2Helper

  def out_of
    Country.count
  end

  def update_data
    if self.users.count != 0
      ## UPDATING AVERAGES (FIRST)##
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

      ## UPDATING RANKINGS (SECOND)##
        update_all_rankings

      ## FINDING PARENT MAX (THIRD)##
        countries = Country.joins(:users).distinct
        max_elect = countries.order(avg_daily_electricity_consumed_per_user: :desc).first.avg_daily_electricity_consumed_per_user
        max_wat = countries.order(avg_daily_water_consumed_per_user: :desc).first.avg_daily_water_consumed_per_user
        max_gas = countries.order(avg_daily_gas_consumed_per_user: :desc).first.avg_daily_gas_consumed_per_user
        max_carb = countries.order(avg_daily_carbon_consumed_per_user: :desc).first.avg_daily_carbon_consumed_per_user
        # (these maxes are from parent region)
        self.max_daily_electricity_consumption = max_elect
        self.max_daily_water_consumption = max_wat
        self.max_daily_gas_consumption = max_gas
        self.max_daily_carbon_consumption = max_carb

      ## SAVING REGIONAL RECORD (LAST)##
        self.save
    end
  end

  def update_all_rankings
      update_electricity_rankings
      update_gas_rankings
      update_carbon_rankings
      update_water_rankings
  end

  def update_electricity_rankings
    e_countries = Country.joins(:users)
        .where.not(avg_daily_electricity_consumed_per_user: [nil, 0])
        .order(avg_daily_electricity_consumed_per_user: :asc)
    unless e_countries.empty?
      oo = e_countries.count
      e_countries.each_with_index do |country, i|
        rank = ElectricityRanking.where(area_type: "Country", area_id: country.id).first
        rank.rank = i
        rank.out_of = oo
        rank.save
      end
    end
  end
  def update_gas_rankings
    g_countries = Country.joins(:users)
        .where.not(avg_daily_gas_consumed_per_user: [nil, 0])
        .order(avg_daily_gas_consumed_per_user: :asc)
    unless g_countries.empty?
      oo = g_countries.count
      g_countries.each_with_index do |country, i|
        rank = GasRanking.where(area_type: "Country", area_id: country.id).first
        rank.rank = i + 1
        rank.out_of = oo
        rank.save
      end
    end
  end

  def update_carbon_rankings
    c_countries = Country.joins(:users)
        .where.not(avg_daily_carbon_consumed_per_user: [nil, 0])
        .order(avg_daily_carbon_consumed_per_user: :asc)
    unless c_countries.empty?
      oo = c_countries.count
      c_countries.each_with_index do |country, i|
        rank = CarbonRanking.where(area_type: "Country", area_id: country.id).first
        rank.rank = i + 1
        rank.out_of = oo
        rank.save
      end
    end
  end
  def update_water_rankings
    w_countries = Country
        .where.not(avg_daily_water_consumed_per_user: [nil, 0])
        .order(avg_daily_water_consumed_per_user: :asc)
    unless w_countries.empty?
      oo = w_countries.count
      w_countries.each_with_index do |country, i|
        rank = WaterRanking.where(area_type: "Country", area_id: country.id).first
        rank.rank = i + 1
        rank.out_of = oo
        rank.save
      end
    end
  end

  # def update_total_electricity_and_carbon_savings
  #   if ElectricBill.joins(:house => {:address => :region}).where(:regions => {country_id: self.id}).count != 0
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
  #   if ElectricBill.joins(:house => {:address => :region}).where(:regions => {country_id: self.id}).count != 0
  #     energy_savings = self.users.map{|u| u.total_electricity_savings }
  #     .flatten.reject(&:nan?)
  #     .reduce(0){|sum, num| sum + num } / self.users.count if self.users.count != 0
  #     self.avg_total_electricity_saved_per_user = energy_savings
  #   end
  # end

  def update_daily_avg_electricity_consumption
      users = self.users.map{|u| u.avg_daily_electricity_consumption }
              .flatten.reject(&:nan?).reject(&:zero?)
      ct = users.length
      energy_consumed = users.reduce(0){|sum, num| sum + num} / ct if ct != 0
      energy_consumed ||= 0.0
      self.avg_daily_electricity_consumed_per_user = energy_consumed
  end

  # def update_total_water_savings
  #   if WaterBill.joins(:house => {:address => :region}).where(:regions => {country_id: self.id}).count != 0
  #     water_saved = self.users.map{|u| u.total_water_savings}
  #               .flatten.reject(&:nan?)
  #               .reduce(0){|sum, num| sum + num}
  #     self.total_water_saved = water_saved
  #   end
  # end
  #
  # def update_daily_avg_water_savings
  #   if WaterBill.joins(:house => {:address => :region}).where(:regions => {country_id: self.id}).count != 0
  #     water_savings = self.users.map{|u| u.total_water_savings }
  #     .flatten.reject(&:nan?)
  #     .reduce(0){|sum, num| sum + num } / self.users.count if self.users.count != 0
  #     self.avg_total_water_saved_per_user = water_savings
  #   end
  # end

  def update_daily_avg_water_consumption
      users = self.users.map{|u| u.avg_daily_water_consumption }
              .flatten
              .reject(&:nan?).reject(&:zero?)
      ct = users.length
      water_consumed = users.reduce(0){|sum, num| sum + num} / ct if ct != 0
      water_consumed ||= 0.0
      self.avg_daily_water_consumed_per_user = water_consumed
  end

  # def update_total_gas_and_carbon_savings
  #   if HeatBill.joins(:house => {:address => :region}).where(:regions => {country_id: self.id}).count != 0
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
  #   if HeatBill.joins(:house => {:address => :region}).where(:regions => {country_id: self.id}).count != 0
  #     gas_savings = self.users.map{|u| u.total_gas_savings }
  #             .flatten.reject(&:nan?)
  #             .reduce(0){|sum, num| sum + num } / self.users.count if self.users.count != 0
  #     self.avg_total_gas_saved_per_user = gas_savings
  #   end
  # end

  def update_daily_avg_gas_consumption
      users = self.users.map{|u| u.avg_daily_gas_consumption }
        .flatten.reject(&:nan?).reject(&:zero?)
      ct = users.length
      gas_consumed = users.reduce(0){|sum, num| sum + num} / ct if ct != 0
      gas_consumed ||= 0.0
      self.avg_daily_gas_consumed_per_user = gas_consumed
  end

  def update_carbon_consumption
    self.avg_daily_carbon_consumed_per_user = combine_average_use(self.avg_daily_electricity_consumed_per_user, self.avg_daily_gas_consumed_per_user)
    self.total_carbon_consumed = combine_average_use(self.total_electricity_consumed, self.total_gas_consumed)
  end

  def update_total_electricity_consumption
    if ElectricBill.joins(:house => {:address => :region}).where(:regions => {country_id: self.id}).count != 0
      energy_consumed = self.users.map{|u| u.avg_daily_electricity_consumption }
              .flatten.reject(&:nan?).reject(&:zero?)
              .reduce(0){|sum, num| sum + num}
      self.total_electricity_consumed = energy_consumed
    end
  end
  def update_total_water_consumption
    if WaterBill.joins(:house => {:address => :region}).where(:regions => {country_id: self.id}).count != 0
      water_consumed = self.users.map{|u| u.total_gallons_logged }
              .flatten
              .reject(&:nan?).reject(&:zero?)
              .reduce(0){|sum, num| sum + num}
      self.total_water_consumed = water_consumed
    end
  end
  def update_total_gas_consumption
    if HeatBill.joins(:house => {:address => :region}).where(:regions => {country_id: self.id}).count != 0
      gas_consumed = self.users.map{|u| u.total_therms_logged }
      .flatten.reject(&:nan?).reject(&:zero?)
      .reduce(0){|sum, num| sum + num}
      self.total_gas_consumed = gas_consumed
    end
  end

  def set_default_ranks
    WaterRanking.create(area_type: "Country", area_id: self.id, rank: nil, arrow: nil)
    ElectricityRanking.create(area_type: "Country", area_id: self.id, rank: nil, arrow: nil)
    GasRanking.create(area_type: "Country", area_id: self.id, rank: nil, arrow: nil)
    CarbonRanking.create(area_type: "Country", area_id: self.id, rank: nil, arrow: nil)
  end

  def set_snapshots
    CountrySnapshot.take_snapshot(self)
  end
end
