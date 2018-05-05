class City < ApplicationRecord
  include CityHelper

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :region_id

  belongs_to :region
  has_many :neighborhoods
  has_many :addresses, through: :neighborhoods
  has_many :houses, through: :addresses
  has_many :users, through: :houses
  has_many :city_snapshots

  before_validation :capitalize_name

  before_create :add_zeros

  def capitalize_name
    self.name = self.name.split(' ')
    .map{|w| w.downcase == 'of' || w.downcase == 'and' ? lowercase(w) : capitalize(w)}
    .join(' ')
  end

  def lowercase(word)
    word.downcase
  end

  def capitalize(word)
    word.capitalize
  end

  def add_zeros
    self.total_electricity_saved = 0
    self.total_water_saved = 0
    self.total_gas_saved = 0
    self.avg_total_electricity_saved_per_user = 0
    self.avg_total_water_saved_per_user = 0
    self.avg_total_gas_saved_per_user = 0
    self.avg_daily_electricity_consumed_per_user = 0
    self.avg_daily_water_consumed_per_user = 0
    self.avg_daily_gas_consumed_per_user = 0
  end
end
