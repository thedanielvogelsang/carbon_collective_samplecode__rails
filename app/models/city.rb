class City < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :region
  has_many :neighborhoods
  has_many :addresses, through: :neighborhoods
  has_many :houses, through: :addresses
  has_many :users, through: :houses

  before_validation :capitalize_name
  def capitalize_name
    self.name = self.name.split(' ')
    .map{|w| w.downcase == 'of' || w.downcase == 'and' ? lowercase(w) : capitalize(w)}
    .join(' ')
  end

  def lowercase(word)
    word.downcase
  end

  def capitalize(word)
    word.capitalize
  end
end
