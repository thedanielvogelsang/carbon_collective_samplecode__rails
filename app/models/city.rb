class City < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :region
  has_many :neighborhoods

  before_validation :capitalize_name
  def capitalize_name
    self.name.split(' ').map{|w| w.capitalize}.join(' ')
  end
end
