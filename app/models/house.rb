class House < ApplicationRecord
  include HouseHelper

  belongs_to :address
  validates_presence_of :total_sq_ft
  validates_presence_of :no_residents

  validates :address_id, presence: true, uniqueness: true

  has_many :user_houses, :dependent => :destroy
  has_many :users, through: :user_houses
  has_many :electric_bills, :dependent => :destroy
  has_many :household_snapshots

  def bills
    self.electric_bills
  end
end
