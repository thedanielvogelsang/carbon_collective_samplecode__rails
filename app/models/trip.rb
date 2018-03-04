require 'trip_helper'
class Trip < ApplicationRecord
  include TripHelper
  before_create :add_trip_name
  after_create :add_carbon_method

  enum trip_type: { neutral: 0, public_transit: 1, mo_ped: 2, electric_car: 3, car: 4, airplane: 5 }
  belongs_to :user
  belongs_to :day

  def total_mileage
    length_miles(self.timestamps)
  end

  def total_time
    length_time(self.created_at, self.stop)
  end

  def co2_produced
    co2produced(self.trip_type, self.timestamps)
  end

  def stop!
    self.stop = DateTime.now
  end

  private
    def add_trip_name
      day = Day.find_or_create_by(date: DateTime.now.strftime('%d %b %Y'))
      self.trip_name = day.date + (day.trips.count + 1).to_s
    end

    def add_carbon_method
      self.mode_of_transport = self.trip_type
      self.save
    end
end
