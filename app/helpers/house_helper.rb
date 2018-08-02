module HouseHelper
  include Co2Helper

# 0.4 ms vs 0.7 w/ users

## used for snapshots -- pending api use ##
  # 0.5 ms

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

  # -- based on bills -- #
  #CONSUMPTION
    #Electricity
      # - total
        def average_total_electricity_consumption_per_resident
          total_electricity_consumption_to_date / self.no_residents
        end
      # - daily
        def average_daily_electricity_consumption_per_resident
          self.electric_bills.map{|b| b.total_kwhs}.compact.flatten.reject(&:nan?)
                    .reduce(0){|s, n| s + n} / self.no_residents
        end
    #Water
      # - total
        def average_total_water_consumption_per_resident
          total_water_consumption_to_date / self.no_residents
        end
      # - daily
        def average_daily_water_consumption_per_resident
          self.wbills.map{|b| b.total_gallons}.compact.flatten.reject(&:nan?)
                    .reduce(0){|s, n| s + n} / self.no_residents
        end
    #Gas
      # - total
        def average_total_gas_consumption_per_resident
          total_gas_consumption_to_date / self.no_residents
        end
      # - daily
        def average_daily_gas_consumption_per_resident
          self.gbills.map{|b| b.total_therms}.compact.flatten.reject(&:nan?)
                    .reduce(0){|s, n| s + n} / self.no_residents
        end
    #Carbon
        def average_total_carbon_consumption_per_resident
          total_carbon_consumption_to_date / self.no_residents
        end

  #SAVINGS
    #Electricity
      # - total
      def average_total_electricity_saved_per_resident
        total_electricity_savings_to_date / self.no_residents
      end
    #Water
      # - total
      def average_total_water_saved_per_resident
        total_water_savings_to_date / self.no_residents
      end
    #Gas
      # - total
      def average_total_gas_saved_per_resident
        total_gas_savings_to_date / self.no_residents
      end

  ## DOUBLE CHECK THIS -- per resident or users?
    def average_total_carbon_saved_per_resident
      total_carbon_savings_to_date / self.no_residents
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

  #Still not accurate actually. Needs to be selected for unique dates...
  def total_days_recorded
    e_days = self.bills.map{|b| (b.end_date - b.start_date).to_i }.reduce(0){|s, n| s + n}
    w_days = self.wbills.map{|b| (b.end_date - b.start_date).to_i }.reduce(0){|s, n| s + n}
    g_days = self.gbills.map{|b| (b.end_date - b.start_date).to_i }.reduce(0){|s, n| s + n}
    return e_days + w_days + g_days
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
end
