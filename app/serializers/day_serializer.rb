class DaySerializer < ActiveModel::Serializer
  attributes :id, :date, :total_co2_used_today, :co2_saved,
             :total_miles_biked, :total_miles_driven

end
