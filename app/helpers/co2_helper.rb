module Co2Helper
  def therms_to_carbon(gas_in_therms)
    #therms to metric tons to lbs
    gas_in_therms * 0.0053 / 0.0004536
  end
  def kwhs_to_carbon(elect_in_kwhs)
    #kwhs to metric tons to lbs
    elect_in_kwhs * 0.000744 / 0.0004536
  end

  def combine_average_use(kwh_avg, therm_avg)
    return ((kwh_avg * 0.000744) + (therm_avg * 0.0053))
  end
end