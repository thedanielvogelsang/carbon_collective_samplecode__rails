class House < ApplicationRecord
  belongs_to :address
  validates_presence_of :total_sq_ft
  validates_presence_of :no_residents
  validates :address_id, presence: true, uniqueness: true

  has_many :user_houses
  has_many :users, through: :user_houses
end
