class Neighborhood < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :city
  has_many :addresses
  has_many :houses, through: :addresses
  has_many :users, through: :houses

  before_validation :capitalize_name
  def capitalize_name
    self.name.split(' ').map{|w| w.capitalize}.join(' ')
  end
end
