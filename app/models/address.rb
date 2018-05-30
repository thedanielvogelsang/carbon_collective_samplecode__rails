class Address < ApplicationRecord
  # Address Helper currently not being used
  include ParserHelper
  include AddressHelper

  validates_presence_of :address_line1

  validates_uniqueness_of :address_line1, scope: [:address_line2, :city_id]

  has_one :house, :dependent => :destroy

  has_many :users, through: :house
  belongs_to :zipcode
  belongs_to :city
  belongs_to :neighborhood, optional: true
  belongs_to :county, optional: true

  has_one :region, through: :city
  has_one :country, through: :region

  before_validation :parse_attrs_for_nil
  before_validation :check_ids, on: [:create, :update]

end
