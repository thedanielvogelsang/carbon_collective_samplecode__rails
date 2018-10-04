module HouseHelper
  include Co2Helper

# 0.4 ms vs 0.7 w/ users

## used for snapshots -- pending api use ##
  # 0.5 ms
  def set_snapshots
    HouseholdSnapshot.take_snapshot(self)
  end

## used for rankings -- pending api use ##
## wont make sense until we use different rank/arrow code for houses;
  def set_default_ranks
    WaterRanking.create(area_type: "House", area_id: self.id, rank: nil, arrow: nil)
    ElectricityRanking.create(area_type: "House", area_id: self.id, rank: nil, arrow: nil)
    GasRanking.create(area_type: "House", area_id: self.id, rank: nil, arrow: nil)
    CarbonRanking.create(area_type: "House", area_id: self.id, rank: nil, arrow: nil)
  end

## attrs must be stored on houses in order to ActiveRecord sorting, these are used to update:

  def update_data
    # # CHANGE THIS LATER: House.all is too broad for beyond Denver, perhaps change to:
    # # # $=> House.joins(:address).joins(:neighborhood).where(:neighborhoods => {id: self.neighborhood.id})
    # # (For houses within neighborhood)
    houses = House.all
    max_elect = houses.order(avg_daily_electricity_consumed_per_user: :desc).first.avg_daily_electricity_consumed_per_user
    max_wat = houses.order(avg_daily_water_consumed_per_user: :desc).first.avg_daily_water_consumed_per_user
    max_gas = houses.order(avg_daily_gas_consumed_per_user: :desc).first.avg_daily_gas_consumed_per_user
    max_carb = houses.order(avg_daily_carbon_consumed_per_user: :desc).first.avg_daily_carbon_consumed_per_user

    self.avg_daily_electricity_consumed_per_user = average_daily_electricity_consumption_per_user
    self.avg_daily_water_consumed_per_user = average_daily_water_consumption_per_user
    self.avg_daily_gas_consumed_per_user = average_daily_gas_consumption_per_user
    self.avg_daily_carbon_consumed_per_user = average_daily_carbon_consumption_per_user
    self.total_electricity_consumed = total_electricity_consumption_to_date
    self.total_water_consumed = total_water_consumption_to_date
    self.total_gas_consumed = total_gas_consumption_to_date
    self.total_carbon_consumed = total_carbon_consumption_to_date
    self.max_daily_electricity_consumption = max_elect
    self.max_daily_water_consumption = max_wat
    self.max_daily_gas_consumption = max_gas
    self.max_daily_carbon_consumption = max_carb
    self.save
  end

  def update_all_rankings
      update_electricity_rankings
      update_gas_rankings
      update_carbon_rankings
      update_water_rankings
  end

  def update_electricity_rankings
    e_houses = House.joins(:address).joins(:neighborhood).joins(:city)
        .where(:cities => {id: self.city.id})
        .where.not(avg_daily_electricity_consumed_per_user: [nil, 0])
        .order(avg_daily_electricity_consumed_per_user: :asc)
    unless e_houses.empty?
      oo = e_houses.count
      e_houses.each_with_index do |house, i|
        rank = ElectricityRanking.where(area_type: "House", area_id: house.id).first
        rank.rank = i
        rank.out_of = oo
        rank.save
      end
    end
  end
  def update_gas_rankings
    g_houses = House.joins(:address).joins(:neighborhood).joins(:city)
        .where(:cities => {id: self.city.id})
        .where.not(avg_daily_gas_consumed_per_user: [nil, 0])
        .order(avg_daily_gas_consumed_per_user: :asc)
    unless g_houses.empty?
      oo = g_houses.count
      g_houses.each_with_index do |house, i|
        rank = GasRanking.where(area_type: "House", area_id: house.id).first
        rank.rank = i + 1
        rank.out_of = oo
        rank.save
      end
    end
  end

  def update_carbon_rankings
    c_houses = House.joins(:address).joins(:neighborhood).joins(:city)
        .where(:cities => {id: self.city.id})
        .where.not(avg_daily_carbon_consumed_per_user: [nil, 0])
        .order(avg_daily_carbon_consumed_per_user: :asc)
    unless c_houses.empty?
      oo = c_houses.count
      c_houses.each_with_index do |house, i|
        rank = CarbonRanking.where(area_type: "House", area_id: house.id).first
        rank.rank = i + 1
        rank.out_of = oo
        rank.save
      end
    end
  end
  def update_water_rankings
    w_houses =  House.joins(:address).joins(:neighborhood).joins(:city)
        .where(:cities => {id: self.city.id})
        .where.not(avg_daily_water_consumed_per_user: [nil, 0])
        .order(avg_daily_water_consumed_per_user: :asc)
    unless w_houses.empty?
      oo = w_houses.count
      w_houses.each_with_index do |house, i|
        rank = WaterRanking.where(area_type: "House", area_id: house.id).first
        rank.rank = i + 1
        rank.out_of = oo
        rank.save
      end
    end
  end

  def house_max(type)
    case(type)
    when "electricity"
      calculate_house_electricity_max
    when "water"
      calculate_house_water_max
    when "gas"
      calculate_house_heat_max
    when "carbon"
      calculate_house_carbon_max
    end
  end

## -- AVERAGE PER USER / RESIDENT -- ##
  # -- based on users -- #
    def average_daily_electricity_consumption_per_user
      users = self.users.map{|u| u.avg_daily_electricity_consumption}.compact.flatten.reject(&:nan?).reject(&:zero?)
      ct = users.length
      if ct > 0
        users.reduce(0){|s,n| s + n} / ct
      else
        0
      end
    end

    def average_daily_carbon_consumption_per_user
      users = self.users.map{|u| u.avg_daily_carbon_consumption}.compact.flatten.reject(&:nan?).reject(&:zero?)
      ct = users.length
      if ct > 0
        users.reduce(0){|s,n| s + n} / ct
      else
        0
      end
    end

    def average_daily_water_consumption_per_user
      users = self.users.map{|u| u.avg_daily_water_consumption}.compact.flatten.reject(&:nan?).reject(&:zero?)
      ct = users.length
      if ct > 0
        users.reduce(0){|s,n| s + n} / ct
      else
        0
      end
    end

    def average_daily_gas_consumption_per_user
      users = self.users.map{|u| u.avg_daily_gas_consumption}.compact.flatten.reject(&:nan?).reject(&:zero?)
      ct = users.length
      if ct > 0
        users.reduce(0){|s,n| s + n} / ct
      else
        0
      end
    end

    def average_daily_carbon_consumption_per_user
      combine_average_use(avg_daily_electricity_consumed_per_user, avg_daily_gas_consumed_per_user)
    end

  # -- based on bills -- #
  #CONSUMPTION
    #Electricity
      # - total
        def average_total_electricity_consumption_per_resident
          if self.no_residents > 0
            total_electricity_consumption_to_date / self.no_residents
          end
        end
      # - daily
        def average_daily_electricity_consumption_per_resident
          if total_electricitybill_days_recorded > 0 && self.no_residents > 0
            res = total_electricity_consumption_to_date.fdiv(total_electricitybill_days_recorded).fdiv(self.no_residents)
          else
            0.0
          end
        end
    #Water
      # - total
        def average_total_water_consumption_per_resident
          if self.no_residents > 0
            total_water_consumption_to_date / self.no_residents
          end
        end
      # - daily
        def average_daily_water_consumption_per_resident
          if total_waterbill_days_recorded > 0 && self.no_residents > 0
            res = total_water_consumption_to_date.fdiv(total_waterbill_days_recorded).fdiv(self.no_residents)
          else
            0.0
          end
        end
    #Gas
      # - total
        def average_total_gas_consumption_per_resident
          if self.no_residents > 0
            total_gas_consumption_to_date / self.no_residents
          end
        end
      # - daily
        def average_daily_gas_consumption_per_resident
          if total_heatbill_days_recorded > 0 && self.no_residents > 0
            res = total_gas_consumption_to_date.fdiv(total_heatbill_days_recorded).fdiv(self.no_residents)
          else
            0.0
          end
        end
    #Carbon
        def average_total_carbon_consumption_per_resident
          if self.no_residents > 0
            total_carbon_consumption_to_date / self.no_residents
          end
        end

  #SAVINGS
    #Electricity
      # - total
      def average_total_electricity_saved_per_resident
        if self.no_residents > 0
          total_electricity_savings_to_date / self.no_residents
        end
      end
    #Water
      # - total
      def average_total_water_saved_per_resident
        if self.no_residents > 0
          total_water_savings_to_date / self.no_residents
        end
      end
    #Gas
      # - total
      def average_total_gas_saved_per_resident
        if self.no_residents > 0
          total_gas_savings_to_date / self.no_residents
        end
      end

  ## DOUBLE CHECK THIS -- per resident or users?
      def average_total_carbon_saved_per_resident
        if self.no_residents > 0
          total_carbon_savings_to_date / self.no_residents
        end
      end
      def total_carbon_savings_to_date
        return combine_average_use(total_electricity_savings_to_date,
                                  total_gas_savings_to_date,
                                  )
      end

## -- HOUSEHOLD AVGS / TOTALS -- ##
# -- based on bills -- #
  def total_spent
    total = []
    self.water_bills.empty? ? nil : self.wbills.each{ |b| total.push(b.price)}
    self.heat_bills.empty? ? nil : self.gbills.each{|b| total.push(b.price)}
    self.electric_bills.empty? ? nil : self.bills.each{|b| total.push(b.price)}
    res_ = total.reject(&:nil?).reduce(0){|s, n| s + n}.to_f.round(2)
  end

  #Good for now. Needs to be selected for unique dates...
  def total_days_recorded
    e_days = self.bills.map{|b| (b.end_date - b.start_date).to_i }.reduce(0){|s, n| s + n}
    w_days = self.wbills.map{|b| (b.end_date - b.start_date).to_i }.reduce(0){|s, n| s + n}
    g_days = self.gbills.map{|b| (b.end_date - b.start_date).to_i }.reduce(0){|s, n| s + n}
    return e_days + w_days + g_days
  end

  def all_bills_to_date
    bills + wbills + gbills
  end

  # total of each bill type
  def total_electricitybill_days_recorded
    self.bills.map{|b| (b.end_date - b.start_date).to_i }.reduce(0){|s,n| s+n}
  end
  def total_waterbill_days_recorded
    self.wbills.map{|b| (b.end_date - b.start_date).to_i }.reduce(0){|s,n| s+n}
  end
  def total_heatbill_days_recorded
    self.gbills.map{|b| (b.end_date - b.start_date).to_i }.reduce(0){|s,n| s+n}
  end

  #Electricity
    #CONSUMPTION
      def total_electricity_consumption_to_date
        self.bills.map{|b| b.total_kwhs }.flatten.reduce(0){|s,n| s+n}
      end
    #SAVINGS
      def total_electricity_savings_to_date
        self.bills.map{|b| b.electricity_saved}.flatten
                  .reduce(0){|s,n| s + n}
      end

      def total_electricity_saved
        total_electricity_savings_to_date
      end


  #Water
    #CONSUMPTION
      def total_water_consumption_to_date
        self.wbills.map{|b| b.total_gallons }.flatten.reduce(0){|s,n| s+n}
      end
    #SAVINGS
      def total_water_savings_to_date
        self.wbills.map{|wb| wb.water_saved}.flatten
                  .reduce(0){|s,n| s + n}
      end
      def total_water_saved
        total_water_savings_to_date
      end

  #Gas
    #CONSUMPTION
      def total_gas_consumption_to_date
        self.gbills.map{|b| b.total_therms }.flatten.reduce(0){|s,n| s+n}
      end
    #SAVINGS
      def total_gas_savings_to_date
        self.gbills.map{|hb| hb.gas_saved}.flatten
                  .reduce(0){|s,n| s + n}
      end
      def total_gas_saved
        total_gas_savings_to_date
      end

  #Carbon
    #CONSUMPTION
      def total_carbon_consumption_to_date
        combine_average_use(
            total_electricity_consumption_to_date, total_gas_consumption_to_date
            )
      end
    #SAVINGS
      def total_carbon_savings_to_date
        combine_average_use(
          total_electricity_savings_to_date, total_gas_savings_to_date
        )
      end
      def total_carbon_saved
        total_carbon_savings_to_date
      end

  # MAX-es
    def calculate_house_electricity_max
      users.sort_by{|u| u.avg_daily_electricity_consumption }.last.avg_daily_electricity_consumption
    end
    def calculate_house_water_max
      users.sort_by{|u| u.avg_daily_water_consumption }.last.avg_daily_water_consumption
    end
    def calculate_house_heat_max
      users.sort_by{|u| u.avg_daily_gas_consumption }.last.avg_daily_gas_consumption
    end
    def calculate_house_carbon_max
      users.sort_by{|u| u.avg_daily_carbon_consumption }.last.avg_daily_carbon_consumption
    end
end
