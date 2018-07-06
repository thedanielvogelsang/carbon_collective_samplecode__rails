class ElectricBillSerializer < ActiveModel::Serializer
  include Co2Helper

  attributes :id, :start_date, :end_date, :no_days, :total_used,
                  :total_saved, :carbon_impact,
                  :house_info, :price, :year
  def start_date
    object.start_date.strftime('%B%e')
  end
  def end_date
    object.end_date.strftime('%B%e')
  end
  def no_days
    (object.end_date - object.start_date).to_i
  end
  def total_used
    object.total_kwhs.to_s + ' kWhs'
  end
  def total_saved
    object.electricity_saved.round(2).to_s + ' kWhs'
  end
  def carbon_impact
    kwhs_to_carbon(object.total_kwhs).round(2).to_s + " lbs co2"
  end
  def house_info
    object.house
  end
  def year
    object.start_date.strftime('%Y')
  end
end
