class House < ApplicationRecord
  include HouseHelper

  belongs_to :address

  validates :address_id, presence: true, uniqueness: true

  has_many :user_houses, dependent: :destroy
  has_many :users, through: :user_houses
  has_many :electric_bills, dependent: :destroy
  has_many :heat_bills, dependent: :destroy
  has_many :water_bills, dependent: :destroy
  has_many :household_snapshots, dependent: :destroy
  has_one :neighborhood, through: :address

  has_many :user_electricity_rankings, :as => :area
  has_many :user_water_rankings, :as => :area
  has_many :user_gas_rankings, :as => :area
  has_many :user_carbon_rankings, :as => :area

  def bills
    self.electric_bills
  end

  def wbills
    self.water_bills
  end

  def gbills
    self.heat_bills
  end
end
