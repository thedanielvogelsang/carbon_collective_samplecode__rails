module Co2Helper
  def therms_to_carbon(gas_in_therms)
    #therms to metric tons to lbs
    gas_in_therms * 0.00548 / 0.0004536
  end
  def kwhs_to_carbon(elect_in_kwhs)
    #kwhs to metric tons to lbs
    elect_in_kwhs * 1.222
  end

  def combine_average_use(kwh_avg, therm_avg)
    kwh_avg = 0 if kwh_avg.to_f.nan?
    therm_avg = 0 if therm_avg.to_f.nan?
    return ((kwh_avg * 1.222) + (therm_avg * 0.0053 / 0.0004536))
  end
end
