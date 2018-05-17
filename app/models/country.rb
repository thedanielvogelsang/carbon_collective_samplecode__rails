class Country < ApplicationRecord
  include CountryHelper

  validates :name, presence: true, uniqueness: true
  has_many :regions
  has_many :cities, through: :regions
  has_many :neighborhoods, through: :cities
  has_many :addresses, through: :neighborhoods
  has_many :houses, through: :addresses
  has_many :users, through: :houses
  has_many :country_snapshots

  before_validation :capitalize_name,
                    :check_name

  before_create :add_zeros, :copy_default_per_capita

  has_one :electricity_ranking, :as => :area
  has_one :water_ranking, :as => :area
  has_one :gas_ranking, :as => :area

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

  def check_name
    self.name == "Usa" ? self.name = "United States of America" : nil
    self.name == "USA" ? self.name = "United States of America" : nil
    self.name == "United States" ? self.name = "United States of America" : nil
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

  def copy_default_per_capita
    default_elect = self.avg_daily_electricity_consumed_per_capita
    default_wat = self.avg_daily_water_consumed_per_capita
    default_gas = self.avg_daily_gas_consumed_per_capita
    self.avg_daily_electricity_consumed_per_user = default_elect if default_elect
    self.avg_daily_water_consumed_per_user = default_wat if default_wat
    self.avg_daily_gas_consumed_per_user = default_gas if default_gas
  end
end
