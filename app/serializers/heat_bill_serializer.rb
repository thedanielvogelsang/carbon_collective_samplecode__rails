class HeatBillSerializer < ActiveModel::Serializer
  include Co2Helper

  attributes :id, :start_date, :end_date, :total_used, :no_days,
                  :total_saved, :carbon_impact, :who, :average_use,
                  :house_info, :price, :year, :no_residents, :average_daily,
                  :who_id

  def start_date
    object.start_date.strftime('%B %e')
  end
  def end_date
    object.end_date.strftime('%B %e')
  end
  def no_days
    (object.end_date - object.start_date).to_i
  end
  def total_used
    object.total_therms.to_s
  end
  def total_saved
    object.gas_saved.round(2).to_s + ' therms'
  end
  def carbon_impact
    therms_to_carbon(object.total_therms).round(2).to_s + " lbs co2"
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
  def who_id
    object.who.slug
  end
  def average_use
    object.average_daily_usage.to_f.round(2)
  end
  def average_daily
    num_days = object.end_date - object.start_date
    '%.2f' % object.total_therms.fdiv(num_days).fdiv(object.no_residents).to_f.round(2)
  end
end
