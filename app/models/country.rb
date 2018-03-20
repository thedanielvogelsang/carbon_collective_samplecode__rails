class Country < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :regions

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
