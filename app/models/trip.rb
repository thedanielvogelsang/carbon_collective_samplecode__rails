require 'trip_helper'
require 'trip_sorter'
class Trip < ApplicationRecord
  attr_accessor :start
  extend TripSorter
  include TripHelper
  after_create :add_trip_name
  after_create :add_carbon_method

  enum trip_type: { neutral: 0, car: 1, mo_ped: 2, electric_car: 3, barge: 4, airplane: 5 }
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

  def start
    self.created_at
  end

  private
    def add_trip_name
      day = Day.find(self.day_id)
      self.trip_name = day.date
    end

    def add_carbon_method
      self.mode_of_transport = self.trip_type
      self.save
    end
end
