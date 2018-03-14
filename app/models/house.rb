class House < ApplicationRecord
  belongs_to :address
  validates_presence_of :total_sq_ft
  validates_presence_of :no_residents
end
