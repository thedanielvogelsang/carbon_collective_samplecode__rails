class Region < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :country
  has_many :cities

  before_validation :capitalize_name
  def capitalize_name
    self.name.split(' ').map{|w| w.capitalize}.join(' ')
  end
end
