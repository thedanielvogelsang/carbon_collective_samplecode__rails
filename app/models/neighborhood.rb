class Neighborhood < ApplicationRecord
  include NeighborhoodHelper

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :city_id

  belongs_to :city
  has_many :addresses
  has_many :houses, through: :addresses
  has_many :users, through: :houses
  has_many :neighborhood_snapshots

  has_one :electricity_ranking, :as => :area
  has_one :water_ranking, :as => :area
  has_one :gas_ranking, :as => :area
  has_one :carbon_ranking, :as => :area

  has_many :user_electricity_rankings, :as => :area
  has_many :user_water_rankings, :as => :area
  has_many :user_gas_rankings, :as => :area
  has_many :user_carbon_rankings, :as => :area

  before_validation :capitalize_name
  before_create :add_zeros
  after_create :set_default_ranks

  def capitalize_name
    if self.name
      self.name = self.name.split(' ')
      .map{|w| w.downcase == 'of' || w.downcase == 'and' ? lowercase(w) : capitalize(w)}
      .join(' ')
    end
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
    self.avg_daily_electricity_consumed_per_capita = 0
    self.avg_daily_water_consumed_per_capita = 0
    self.avg_daily_gas_consumed_per_capita = 0
  end
end
