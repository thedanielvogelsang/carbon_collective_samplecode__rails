class Address < ApplicationRecord
  # Address Helper currently not being used
  include AddressHelper

  validates_presence_of :address_line1

  validates_uniqueness_of :address_line1, scope: :city_id

  has_one :house, :dependent => :destroy

  has_many :users, through: :house
  belongs_to :zipcode
  belongs_to :city
  belongs_to :neighborhood, optional: true

  has_one :region, through: :city
  has_one :country, through: :region

  # before_validation :check_associations, on: [:create, :update]

end
