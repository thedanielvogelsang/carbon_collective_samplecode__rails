class Address < ApplicationRecord
  has_one :house
  has_many :users, through: :house
  belongs_to :zipcode
  belongs_to :neighborhood

  before_save :check_neighborhood

  def check_neighborhood
    byebug
    self.neighborhood_id ||= self.zipcode.zipcode
  end
end
