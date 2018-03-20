class Country < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :regions

  before_validation :check_name

  def check_name
    self.name == "USA" ? self.name = "United States of America" : nil
    self.name == "United States" ? self.name = "United States of America" : nil
  end
end
