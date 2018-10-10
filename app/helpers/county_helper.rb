module CountyHelper
  include Co2Helper

  def out_of
    County.where(region: self.region).joins(:users).count
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
        rId = self.region.id
        counties = County.where(region_id: rId).joins(:users).distinct
        max_elect = counties.order(avg_daily_electricity_consumed_per_user: :desc).first.avg_daily_electricity_consumed_per_user
        max_wat = counties.order(avg_daily_water_consumed_per_user: :desc).first.avg_daily_water_consumed_per_user
        max_gas = counties.order(avg_daily_gas_consumed_per_user: :desc).first.avg_daily_gas_consumed_per_user
        max_carb = counties.order(avg_daily_carbon_consumed_per_user: :desc).first.avg_daily_carbon_consumed_per_user
        # (these maxes are from parent region)
        self.max_regional_avg_electricity_consumption = max_elect
        self.max_regional_avg_water_consumption = max_wat
        self.max_regional_avg_gas_consumption = max_gas
        self.max_regional_avg_carbon_consumption = max_carb

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
    e_counties = County.where(region_id: self.region.id)
        .where.not(avg_daily_electricity_consumed_per_user: [nil, 0])
        .order(avg_daily_electricity_consumed_per_user: :asc)
    unless e_counties.empty?
      oo = e_counties.count
      e_counties.each_with_index do |county, i|
        rank = ElectricityRanking.where(area_type: "County", area_id: county.id).first
        prev_rank = rank.rank
        rank.rank = i + 1
        if prev_rank
          rank.rank > prev_rank ? rank.arrow = true : rank.rank == prev_rank ? rank.arrow = nil : rank.arrow = false
        end
        rank.out_of = oo
        rank.save
      end
    end
  end
  def update_gas_rankings
    g_counties = County.where(region_id: self.region.id)
        .where.not(avg_daily_gas_consumed_per_user: [nil, 0])
        .order(avg_daily_gas_consumed_per_user: :asc)
    unless g_counties.empty?
      oo = g_counties.count
      g_counties.each_with_index do |county, i|
        rank = GasRanking.where(area_type: "County", area_id: county.id).first
        prev_rank = rank.rank
        rank.rank = i + 1
        if prev_rank
          rank.rank > prev_rank ? rank.arrow = true : rank.rank == prev_rank ? rank.arrow = nil : rank.arrow = false
        end
        rank.out_of = oo
        rank.save
      end
    end
  end

  def update_carbon_rankings
    c_counties = County.where(region_id: self.region.id)
        .where.not(avg_daily_carbon_consumed_per_user: [nil, 0])
        .order(avg_daily_carbon_consumed_per_user: :asc)
    unless c_counties.empty?
      oo = c_counties.count
      c_counties.each_with_index do |county, i|
        rank = CarbonRanking.where(area_type: "County", area_id: county.id).first
        prev_rank = rank.rank
        rank.rank = i + 1
        if prev_rank
          rank.rank > prev_rank ? rank.arrow = true : rank.rank == prev_rank ? rank.arrow = nil : rank.arrow = false
        end
        rank.out_of = oo
        rank.save
      end
    end
  end
  def update_water_rankings
    w_counties = County.where(region_id: self.region.id)
        .where.not(avg_daily_water_consumed_per_user: [nil, 0])
        .order(avg_daily_water_consumed_per_user: :asc)
    unless w_counties.empty?
      oo = w_counties.count
      w_counties.each_with_index do |county, i|
        rank = WaterRanking.where(area_type: "County", area_id: county.id).first
        prev_rank = rank.rank
        rank.rank = i + 1
        if prev_rank
          rank.rank > prev_rank ? rank.arrow = true : rank.rank == prev_rank ? rank.arrow = nil : rank.arrow = false
        end
        rank.out_of = oo
        rank.save
      end
    end
  end

  # def update_total_electricity_and_carbon_savings
  #   if ElectricBill.joins(:house => :address).where(:addresses => {county_id: self.id}).count != 0
  #     energy_saved = self.users.map{|u| u.total_electricity_savings}
  #               .flatten.reject(&:nan?).reject(&:zero?)
  #               .reduce(0){|sum, num| sum + num}
  #     self.total_electricity_saved = energy_saved
  #     carbon_ranking = self.carbon_ranking
  #     carbon_ranking.total_carbon_saved += kwhs_to_carbon(energy_saved)
  #     carbon_ranking.save
  #   end
  # end
  #
  # def update_daily_avg_electricity_savings
  #   if ElectricBill.joins(:house => :address).where(:addresses => {county_id: self.id}).count != 0
  #     energy_savings = self.users.map{|u| u.total_electricity_savings }
  #             .flatten.reject(&:nan?).reject(&:zero?)
  #             .reduce(0){|sum, num| sum + num } / self.users.count if ct != 0
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
  #   if WaterBill.joins(:house => :address).where(:addresses => {county_id: self.id}).count != 0
  #     water_saved = self.users.map{|u| u.total_water_savings}
  #               .flatten
  #               .reject(&:nan?).reject(&:zero?)
  #               .reduce(0){|sum, num| sum + num}
  #     self.total_water_saved = water_saved
  #   end
  # end
  #
  # def update_daily_avg_water_savings
  #   if WaterBill.joins(:house => :address).where(:addresses => {county_id: self.id}).count != 0
  #     water_savings = self.users.map{|u| u.total_water_savings }
  #             .flatten
  #             .reject(&:nan?).reject(&:zero?)
  #             .reduce(0){|sum, num| sum + num } / self.users.count if self.users.count != 0
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
  #   if HeatBill.joins(:house => :address).where(:addresses => {county_id: self.id}).count != 0
  #     gas_saved = self.users.map{|u| u.total_gas_savings}
  #               .flatten.reject(&:nan?).reject(&:zero?)
  #               .reduce(0){|sum, num| sum + num}
  #     self.total_gas_saved = gas_saved
  #     carbon_ranking = self.carbon_ranking
  #     carbon_ranking.total_carbon_saved += therms_to_carbon(gas_saved)
  #     carbon_ranking.save
  #   end
  # end
  #
  # def update_daily_avg_gas_savings
  #   if HeatBill.joins(:house => :address).where(:addresses => {county_id: self.id}).count != 0
  #     gas_savings = self.users.map{|u| u.total_gas_savings }
  #             .flatten.reject(&:nan?).reject(&:zero?)
  #             .reduce(0){|sum, num| sum + num } / self.users.count if self.users.count != 0
  #     self.avg_total_gas_saved_per_user = gas_savings
  #   end
  # end

  def update_daily_avg_gas_consumption
    if HeatBill.joins(:house => :address).where(:addresses => {county_id: self.id}).count != 0
      users = self.users.map{|u| u.avg_daily_gas_consumption }
              .flatten.reject(&:nan?).reject(&:zero?)
      ct = users.length
      gas_consumed = users.reduce(0){|sum, num| sum + num} / ct if ct != 0
      gas_consumed ||= 0.0
      self.avg_daily_gas_consumed_per_user = gas_consumed
    end
  end

  def update_carbon_consumption
    self.avg_daily_carbon_consumed_per_user = combine_average_use(self.avg_daily_electricity_consumed_per_user, self.avg_daily_gas_consumed_per_user)
    self.total_carbon_consumed = combine_average_use(self.total_electricity_consumed, self.total_gas_consumed)
  end

  def update_total_electricity_consumption
      energy_consumed = self.users.map{|u| u.total_kwhs_logged }
              .flatten.reject(&:nan?).reject(&:zero?)
              .reduce(0){|sum, num| sum + num}
      self.total_electricity_consumed = energy_consumed
  end
  def update_total_water_consumption
    if WaterBill.joins(:house => :address).where(:addresses => {county_id: self.id}).count != 0
      water_consumed = self.users.map{|u| u.total_gallons_logged}
              .flatten.reject(&:nan?).reject(&:zero?)
              .reduce(0){|sum, num| sum + num}
      self.total_water_consumed = water_consumed
    end
  end
  def update_total_gas_consumption
    if HeatBill.joins(:house => :address).where(:addresses => {county_id: self.id}).count != 0
      gas_consumed = self.users.map{|u| u.total_therms_logged }
              .flatten.reject(&:nan?).reject(&:zero?)
              .reduce(0){|sum, num| sum + num}
      self.total_gas_consumed = gas_consumed
    end
  end

  def set_default_ranks
    WaterRanking.create(area_type: "County", area_id: self.id, rank: nil, arrow: nil)
    ElectricityRanking.create(area_type: "County", area_id: self.id, rank: nil, arrow: nil)
    GasRanking.create(area_type: "County", area_id: self.id, rank: nil, arrow: nil)
    CarbonRanking.create(area_type: "County", area_id: self.id, rank: nil, arrow: nil)
  end

  def set_snapshots
    CountySnapshot.take_snapshot(self)
  end
end
