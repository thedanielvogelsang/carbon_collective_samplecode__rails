class HeatBillSerializer < ActiveModel::Serializer
  include Co2Helper

  attributes :id, :start_date, :end_date, :total_used,
                  :total_saved, :carbon_impact,
                  :house_info, :price

  def total_used
    object.total_therms.to_s + ' therms'
  end
  def total_saved
    object.gas_saved.round(2).to_s + ' therms'
  end
  def carbon_impact
    therms_to_carbon(object.gas_saved).round(3).to_s + " lbs co2"
  end
  def house_info
    object.house
  end
end
