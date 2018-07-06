class WaterBillSerializer < ActiveModel::Serializer

  attributes :id, :start_date, :end_date, :total_used,
                  :total_saved, :no_days, :who,
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
    object.total_gallons.to_s + ' gallons'
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
end
