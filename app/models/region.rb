class Region < ApplicationRecord
  include RegionHelper

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :country_id

  belongs_to :country
  has_many :cities
  has_many :neighborhoods, through: :cities
  has_many :addresses, through: :neighborhoods
  has_many :houses, through: :addresses
  has_many :users, through: :houses
  has_many :region_snapshots

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

  def has_average?
    true if self.avg_daily_energy_consumed_per_capita
  end

  def add_zeros
    self.total_energy_saved = 0
    self.avg_total_energy_saved_per_user = 0
    self.avg_daily_energy_consumed_per_user = 0
  end
end
