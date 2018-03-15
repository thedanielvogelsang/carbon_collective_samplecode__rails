class Address < ApplicationRecord
  has_many :user_addresses
  has_many :users, through: :user_addresses
  has_one :house
  belongs_to :zipcode

  attr_accessor :address_line1
  # before_validation :parse_address
  geocoded_by :geocoder_string do |obj, results|
    if geo = results.first
      unit = geo.data['address_components'][0]['long_name']
      obj.address_line1 = geo.street_address
      obj.address_line2 = unit if geo.street_address.scan(unit).empty?
      obj.city = geo.city
      obj.county = geo.data['address_components'][-4]['long_name']
      obj.state = geo.state
      obj.zipcode_id = Zipcode.find_or_create_by(zipcode: geo.postal_code).id
      obj.country = geo.country
      byebug
    end
  end

  before_validation :geocode

end
