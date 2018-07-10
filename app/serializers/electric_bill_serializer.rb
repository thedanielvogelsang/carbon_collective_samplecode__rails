class ElectricBillSerializer < ActiveModel::Serializer
  include Co2Helper

  attributes :id, :start_date, :end_date, :no_days, :total_used,
                  :total_saved, :carbon_impact, :who, :average_use,
                  :house_info, :price, :year, :no_residents, :average_daily
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
    object.total_kwhs.to_s
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
  def who
    object.who.first
  end
  def average_use
    (object.total_kwhs / object.no_residents).to_s
  end
  def average_daily
    num_days = object.end_date - object.start_date
    object.total_kwhs.fdiv(num_days).to_f.round(2)
  end
end
