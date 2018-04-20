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

  before_validation :capitalize_name

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
end
