class WaterBillSerializer < ActiveModel::Serializer

  attributes :id, :start_date, :end_date, :total_used,
                  :total_saved,
                  :house_info, :price

  def total_used
    object.total_gallons.to_s + ' gallons'
  end
  def total_saved
    object.water_saved.round(2).to_s + ' gallons'
  end
  def house_info
    object.house
  end
end
