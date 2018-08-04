class House < ApplicationRecord
  include HouseHelper

  belongs_to :address

  validates :address_id, presence: true, uniqueness: true

  before_save :no_residents_zeroed?
  # after_save :destroy_if_no_residents

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

  def no_residents_zeroed?
    self.no_residents == 0 ? erase_bill_history : nil
  end

  def erase_bill_history
    ElectricBill.joins(:house).where(:houses => {id: self.id}).destroy_all
    WaterBill.joins(:house).where(:houses => {id: self.id}).destroy_all
    HeatBill.joins(:house).where(:houses => {id: self.id}).destroy_all
  end

end
