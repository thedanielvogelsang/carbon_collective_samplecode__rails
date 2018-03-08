require 'day_helper'

class Day < ApplicationRecord
  include DayHelper
  validates :date, presence: true, uniqueness: true
  has_many :trips

  before_validation :parse_date_time

  private
    def parse_date_time
      self.date.class == DateTime ? self.date.strftime('%b %d, %Y') : self.date = DateTime.parse(self.date).strftime('%b %d, %Y')
    end
end
