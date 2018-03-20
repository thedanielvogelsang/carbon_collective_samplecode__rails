class Country < ApplicationRecord
  include CountryHelper
  validates :name, presence: true, uniqueness: true
  has_many :regions
  has_many :cities, through: :regions
  has_many :neighborhoods, through: :cities
  has_many :addresses, through: :neighborhoods
  has_many :houses, through: :addresses
  has_many :users, through: :houses

  before_validation :capitalize_name,
                    :check_name

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

  def check_name
    self.name == "USA" ? self.name = "United States of America" : nil
    self.name == "United States" ? self.name = "United States of America" : nil
  end
end
