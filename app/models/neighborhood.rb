class Neighborhood < ApplicationRecord
  belongs_to :city
  has_many :addresses
  has_many :houses, through: :addresses
  has_many :users, through: :houses
end
