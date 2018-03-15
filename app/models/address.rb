class Address < ApplicationRecord
  has_many :user_addresses
  has_many :users, through: :user_addresses
  has_one :house
  
  # before_validation :parse_address

  attr_accessor :address_line1

  def parse_address
    zip = self.address_line1.scan(/\b(\d{5})\b/).flatten[0]
    self.zipcode_id = Zipcode.find_or_create_by(zipcode: zip).id
  end
end
