module Co2Helper
  def therms_to_carbon(gas_in_therms)
    gas_in_therms * 0.0053
  end
  def kwhs_to_carbon(elect_in_kwhs)
    elect_in_kwhs * 0.000744
  end

  def combine_average_use(kwh_avg, therm_avg)
    return ((kwh_avg * 0.000744) + (therm_avg * 0.0053))
  end
end
