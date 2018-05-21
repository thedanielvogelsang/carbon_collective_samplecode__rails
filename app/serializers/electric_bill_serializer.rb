class ElectricBillSerializer < ActiveModel::Serializer
  include Co2Helper

  attributes :id, :start_date, :end_date, :total_used,
                  :total_saved, :carbon_impact,
                  :house_info, :price

  def total_used
    object.total_kwhs.to_s + ' kwhs'
  end
  def total_saved
    object.electricity_saved.round(2).to_s + ' kwhs'
  end
  def carbon_impact
    kwhs_to_carbon(object.electricity_saved).round(3).to_s + " lbs co2"
  end
  def house_info
    object.house
  end
end
