class WaterBillSerializer < ActiveModel::Serializer

  attributes :id, :start_date, :end_date, :total_used,
                  :total_saved, :no_days, :who, :average_use,
                  :house_info, :price, :year, :no_residents, :average_daily
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
    object.total_gallons.to_s
  end
  def total_saved
    object.water_saved.round(2).to_s + ' gallons'
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
    object.average_daily_usage.to_f.round(2)
  end
  def average_daily
    num_days = object.end_date - object.start_date
    '%.2f' % object.total_gallons.fdiv(num_days).fdiv(object.no_residents).to_f.round(2)
  end
end
